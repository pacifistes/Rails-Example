module VehiclesHelper
  # Render a checkbox group filter
  def checkbox_filter_group(name, options, selected_values, label: nil)
    label_text = label || name.to_s.humanize
    selected = Array(selected_values).reject(&:blank?).map(&:to_s)
    
    checkboxes = options.map do |option|
      value = option.is_a?(Array) ? option[1] : option
      display = option.is_a?(Array) ? option[0] : option.to_s.humanize
      checked = selected.include?(value.to_s)
      
      content_tag(:label, class: "flex items-center cursor-pointer hover:bg-gray-50 p-1 rounded") do
        check_box_tag("#{name}[]", value, checked, class: "rounded border-gray-300 text-blue-600 focus:ring-blue-500") +
        content_tag(:span, display, class: "ml-2 text-sm text-gray-700")
      end
    end
    
    content_tag(:div) do
      content_tag(:label, label_text, class: "block text-sm font-medium text-gray-700 mb-2") +
      content_tag(:div, safe_join(checkboxes), class: "space-y-2 border border-gray-200 rounded-md p-3 max-h-32 overflow-y-auto")
    end
  end

  # Render a number field filter
  def number_filter_field(form, field_name, options = {})
    default_options = {
      step: 0.01,
      min: 0,
      placeholder: field_name.to_s.humanize,
      class: "w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
    }
    
    merged_options = default_options.merge(options)
    value = @filter_params&.dig(field_name)
    
    form.number_field(field_name, merged_options.merge(value: value))
  end

  # Get selected values for a filter
  def selected_filter_values(key)
    Array(@filter_params&.dig(key)).reject(&:blank?)
  end
end
