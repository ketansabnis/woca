class CompanyObserver < Mongoid::Observer
  include ApplicationHelper

  def after_create company
    company.set(company_code: "#{company.name.tr('^A-Za-z', '')[0..4].upcase}_#{company.company_id}") if company.company_code.blank?
  end
end
