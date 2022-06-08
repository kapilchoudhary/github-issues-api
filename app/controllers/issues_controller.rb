class IssuesController < ApplicationController
  before_action :authorize_request
  before_action :set_issue, only: %i[ show update destroy ]

  def index
    @issues = Issue.all
    @issues = @issues.filter_by_id(params[:id]) if params[:id].present?
    render json: {total: Issue.count, issues: @issues.paginate(page: params[:page], per_page: 50) }
  end

  def show; end

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
      render json: @issue, status: :updated
    else
      render json: @issue.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @issue.destroy
    render json: @issue
  end

  private

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:title, :description)
  end
end
