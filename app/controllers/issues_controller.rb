class IssuesController < ApplicationController
  before_action :authorize_request
  before_action :set_issue, only: %i[ show update destroy ]
  before_action :valid_user, only: %i[ update destroy ]

  def index
    issues = filter_issues
    render json: { total: Issue.count,
                   issues: issues.paginate(page: params[:page], per_page: 50) }
  end

  def show
    render json: @issue.as_json
  end

  def create
    @issue = @current_user.issues.new(issue_params)

    if @issue.save
      render json: @issue, status: :created
    else
      render json: @issue.errors, status: :unprocessable_entity
    end
  end

  def update
    if @issue.update(issue_params)
      head :no_content
    else
      render json: @issue.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @issue.destroy
    head :no_content
  end

  private

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:title, :description)
  end

  def valid_user
    return true if @issue.user.id == @current_user.id

    response_msg = "User is not valid"
    render json: response_msg
  end

  def filter_issues
    issues = Issue.all
    issues = issues.filter_by_id(params[:id]) if params[:id].present?
    issues = issues.filter_by_title(params[:title]) if params[:title].present?
    issues = issues.filter_by_description(params[:description]) if params[:description].present?

    issues
  end
end
