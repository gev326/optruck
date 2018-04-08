module ReportsHelper
  @@report = []
  @@search_params = {}

  def self.get_current_report
    @@report
  end

  def self.set_current_report(report)
    @@report = report
  end

  def self.get_current_search_params
    @@search_params
  end

  def self.set_current_search_params(params)
    @@search_params = params
  end

  def self.reset
    @@report = []
    @@search_params = {}
  end
end
