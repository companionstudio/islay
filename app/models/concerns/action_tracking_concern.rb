# A concern responsible for logging changes to a record that includes it.
# Does lots of clever stuff automatically, generally it's as simple as
# including this module and passing a block to ::log_message
module ActionTrackingConcern
  extend ActiveSupport::Concern

  # When working out what's changed, don't consider these fields
  EXCLUDE_FIELDS_FROM_DIFF = ['updated_at'].freeze

  included do
    has_many :user_action_logs, as: :target

    before_save :update_user_ids
    belongs_to :creator, :class_name => 'User', optional: true
    belongs_to :updater, :class_name => 'User', optional: true

    User.track_class(self)

    class_attribute :user_action_log_generator, :action_log_description_method, :action_log_url_parameters_method

    # Default generator
    self.user_action_log_generator = lambda {|label, record|
      changes = if record.previous_changes
        "#{record.previous_changes.except(*ActionTrackingConcern::EXCLUDE_FIELDS_FROM_DIFF).keys.map(&:humanize).join(', ')} "
      end
      "#{label} #{changes} #{record.class.to_s.underscore.humanize} #{record.try(:record_name)}"
    }

    #Default description and URL params
    self.action_log_description_method = :action_log_description_text
    self.action_log_url_parameters_method = :action_log_url_param_values

    @action_logging_paused = false

    before_save   :collate_changes
    after_create  :log_on_create
    after_update  :log_on_update
    after_destroy :log_on_destroy
  end

  #Stop the logger, useful for batched events that we don't want to log individually
  def pause_logging
    @action_logging_paused = true
  end

  #Resume the logger
  def resume_logging
    @action_logging_paused = false
  end

  # Check if the target already has a log for the given action
  #
  # @param Symbol action
  # @return Boolean
  def has_log_for_action?(action)
    logs.where(:action => action).exists?
  end

  # Generates the actual log.
  #
  # @param String label
  # @param Symbol action
  # @return ActivityLog
  def log!(label, action)
    opts = {}

    # Store the diff (if any)
    opts[:payload] = collated_changes

    opts[:notes] = user_action_log_generator.call(label, self)

    originating_user = Thread.current[:current_user] || User.system

    UserActionLog.for(originating_user, action, self, opts) unless @action_logging_paused
  end

  # Call the including model's description method
  def action_log_description
    send self.class.action_log_description_method
  end

  # Call the including model's url params method
  def action_log_url_params
    send self.class.action_log_url_parameters_method
  end

  def action_log_description_text
    self.class.name.demodulize.underscore.humanize
  end

  def action_log_url_param_values
    self
  end

  private

  # Collate previous_changes on the model itself, plus any child records
  attr_accessor :collated_changes

  def collate_changes
    @collated_changes ||= changes
  end

  # Generates a log for the creation of a record.
  #
  # @return ActivityLog
  def log_on_create
    log!("Created", :create)
  end

  # Generates a log when the record is updated. It also accounts for models
  # which use permanent record's deleted_at behaviour.
  #
  # @return ActivityLog
  def log_on_update
    if respond_to?(:deleted_at) and deleted_at?
      label = 'Deleted'
      action = :delete
    else
      # This step handles create actions triggered by 'find_or_create_by' showing up as an update action.
      # If the created_at date goes from null to a date, it's actually a create event
      if previous_changes.include?(:created_at) and previous_changes[:created_at][0] == nil
        label = 'Created'
        action = :create
      else
        label = 'Updated'
        action = :update
      end
    end

    log!(label, action)
  end

  # Logs the deletion of a record. Will only be called when the record in
  # question does not have a deleted_at column i.e. is actually removed
  # from the database.
  #
  # @return ActivityLog
  def log_on_destroy
    log!('Deleted', :delete)
  end

  module ClassMethods
    # Turns on automatic logging, with messages generated by the provided block.
    #
    # @param Proc blk
    # @return nil
    def log_message(&blk)
      self.user_action_log_generator = blk
      nil
    end

    # Fetch the description from the log from the provided method
    def action_log_description(method_name)
      self.action_log_description_method = method_name
    end

    # Fetch the description from the log from the provided method
    def action_log_url_params(method_name)
      self.action_log_url_parameters_method = method_name
    end
  end
end
