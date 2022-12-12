class MoneyInput < SimpleForm::Inputs::NumericInput
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options.merge(placeholder: '$'), wrapper_options)

    @builder.number_field(attribute_name, merged_input_options)
  end
end
