class Admin::CompaniesController < AdminController
  before_action :set_company, except: %i[index export new create]
  before_action :authorize_resource
  around_action :apply_policy_scope, only: %i[index export]

  def index
    @companies = Company.build_criteria params
    if params[:fltrs].present? && params[:fltrs][:_id].present?
      redirect_to admin_company_path(params[:fltrs][:_id])
    else
      @companies = @companies.paginate(page: params[:page] || 1, per_page: params[:per_page])
    end
  end

  def new
    @company = Company.new
    render layout: false
  end
  
  def edit
    render layout: false
  end

  def update
    @company.assign_attributes(permitted_attributes([:admin, @company]))
    respond_to do |format|
      if @company.save
        format.html { redirect_back fallback_location: root_path, notice: 'Company successfully updated.' }
        format.json { render json: @company }
      else
        format.html { render :edit }
        format.json { render json: {errors: @company.errors.full_messages.flatten}, status: :unprocessable_entity }
      end
    end
  end

  def create
    @company = Company.new(permitted_attributes([current_user.role.to_sym, Company.new]))
    authorize [current_user.role.to_sym, @company]
    respond_to do |format|
      if @company.save
        format.html { redirect_to admin_companies_path, notice: 'Company was successfully created.' }
        format.json { render json: @company, status: :created }
      else
        format.html { render :new }
        format.json { render json: { errors: @company.errors.full_messages.uniq }, status: :unprocessable_entity }
      end
    end
  end


  private
  def set_company
    @company = Company.find params[:id]
  end

  def authorize_resource
    if %w[index export].include?(params[:action])
      authorize [current_user.role.to_sym, Company]
    elsif params[:action] == 'new' || params[:action] == 'create'
      if params[:role].present?
        authorize [current_user.role.to_sym, Company.new]
      else
        authorize [current_user.role.to_sym, Company.new]
      end
    else
      authorize [current_user.role.to_sym, @company]
    end
  end

  def apply_policy_scope
    custom_scope = Company.where(Company.user_based_scope(current_user, params))
    Company.with_scope(policy_scope(custom_scope)) do
      yield
    end
  end
end
