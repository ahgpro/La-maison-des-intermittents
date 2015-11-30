class ProjectsController < ApplicationController

 before_action :find_project, only: [:show, :destroy]



  def index
    # if params[:search] and (not params[:search][:job].blank? or not params[:search][:address].blank?)
    if params[:search][:job_id] && params[:search][:address]
      @projects = Project.where(address: params[:search][:address]).where(job_id: params[:search][:job_id])
    elsif params[:search][:address]
      @projects = Project.where(job_id: params[:search][:job_id])
    elsif params[:search][:job_id]
      @projects = Project.where(address: params[:search][:address])
    else
      @projects = policy_scope(Project)
    end
  end

  def show
    @project_job = ProjectJob.new
    @project = Project.find(params[:id])
  end
  def new
    @project = Project.new
    authorize @project
  end

  def create
    @project = current_user.projects.new(project_params)
    authorize @project
    if @project.save
      redirect_to @project

    else
      render :new
    end
  end


  def destroy
    @project.destroy
    redirect_to projects_path
  end

  private

  def find_project
    @project = Project.find(project_params[:id])
    authorize @project
  end

  def project_params
    params.permit(:job, :title, :description, :media, :id)
  end

end

