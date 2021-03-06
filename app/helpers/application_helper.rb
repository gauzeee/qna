module ApplicationHelper
  FLASH_TYPES = { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }.freeze

  def bootstrap_class_for(flash_type)
    FLASH_TYPES[flash_type.to_sym] || flash_type.to_s
  end

  def flash_alerts
    massages = ''
    flash.each { |key, value| massages << content_tag(:p, value, class: "flash #{bootstrap_class_for(key)}") }
    massages.html_safe
  end
end
