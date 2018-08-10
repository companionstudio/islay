//= require jquery
//= require ./namespace
//= require ../../vendor/underscore
//= require ../../vendor/backbone
//= require ../../vendor/jquery.sortable
//= require ../../vendor/select2
//= require ../../vendor/kalendae
//= require ../../vendor/mustache
//= require ../../vendor/jquery.stickytableheaders.min
//= require ../../vendor/jquery.cookie
//= require ../../vendor/jquery.transit
//= require ../../vendor/markdown-js
//= require ../../vendor/medium-editor
//= require ../../vendor/medium-editor.markdown
//= require ../../vendor/moment
//= require ../../vendor/timepicker
//= require_tree .
//= require_extensions

// Customise moment so it puts days first. This is a bit cheaper than putting
// in support for languages.
moment.lang('en', {
  longDateFormat : {
    LT: "h:mm A",
    L: "DD/MM/YYYY - h:mm A",
    l: "D/M/YYYY",
    LL: "MMMM Do YYYY",
    ll: "MMM D YYYY",
    LLL: "MMMM Do YYYY LT",
    lll: "MMM D YYYY LT",
    LLLL: "dddd, MMMM Do YYYY LT",
    llll: "ddd, MMM D YYYY LT"
  }
});

$SP.where('.[edit, new, create, update]').select('#islay-form').run(function(form) {
  form.find('.boolean :checkbox').islayCheckbox();
  form.find('.boolean_depressed :checkbox, .destroy :checkbox').islayCheckbox({mode: 'depressed'});
  form.find('.radio_buttons').islayRadioButtons();
  form.find('.select select').islaySelect();
  form.find('.multi_select select').islaySelect();
  form.find('.tree_select select').islaySelect('tree');
  form.find('.multi_asset select').islayAssetPicker('multi');
  form.find('.single_asset select').islayAssetPicker('single');
  form.find('input[name*="tag_summary"]').islaySelect('tags');
  form.find('input.metadata-tags').islaySelect('tags');
  form.find('.date_picker input').islayDatePicker();
  form.find('.time_picker input').islayTimePicker();
  form.find('.field textarea').islayMarkdownEditor();
  form.find('.islay-toggle').islayToggle();
  form.find('.field.position input').islaySpinControl({reversed: true});
  form.find('.field.position input').islaySpinControl({reversed: true});
  form.islayFormTabs();
});

$SP.where('.[show, index]').select('table.sortable').run(function(table) {
  var SortableTable = new Islay.SortableTable({el: $(table).closest('form')});
});

$SP.where('.[show, edit, create, update]').select('div.collapsible, li.collapsible').run(function(collection) {
  _.each(collection, function(collapser){
    var Collapsible = new Islay.Collapsible({el: $(collapser)});
  });
});

$SP.where('islay-admin-pages.[edit, update]').select('.islay-page-features', 'islayPageFeatures');

$(function() {
  $('#content .time').not('.field, label, input').islayLocaliseTime();

  // DELETE DIALOG
  $('#content .delete, #content .delete, #footer .delete').click(function(e){
    var dialog = new Islay.Dialogs.Confirmation({url: e.target.href, title: e.target.title});
    e.preventDefault();
  });

  $('#islay-add-item').on('click', function(e) {
    var $target = $(this);
    if ($target.data('addDialog')) {
      $target.data('addDialog').show();
    }
    else {
      var dialog = new Islay.Dialogs.Add({url: $target.attr('href'), title: $target.attr('title')});
      $target.data('addDialog', dialog);
    }

    e.preventDefault();
  });

  $('.islay-global-search [type="text"]').islaySearch();

  $('button.print').click(function(){window.print()})

  // Where specified, make table headers stick to the top of the screen
  $('#content table.fixed-header').stickyTableHeaders({fixedOffset: $('.islay-layout-header')});

  $SP.init();
});
