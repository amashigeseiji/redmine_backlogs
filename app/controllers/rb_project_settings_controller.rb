include RbCommonHelper
include ProjectsHelper

class RbProjectSettingsController < RbApplicationController
  unloadable

  def project_settings
    enabled = false
    enabled_scrum_stats = false
    calculate_sprint_name = ""
    calculate_with_other_project = ""
    if request.post? and params[:settings]
      enabled = true if params[:settings]["show_stories_from_subprojects"]=="enabled"
      enabled_scrum_stats = true if params[:settings]["show_in_scrum_stats"]=="enabled"
      calculate_sprint_name = params[:settings]["calculate_sprint_name"] if params[:settings]["calculate_sprint_name"]
      calculate_with_other_project = params[:settings]["calculate_with_other_project"] if params[:settings]["calculate_with_other_project"]
    end
    settings = @project.rb_project_settings
    settings.show_stories_from_subprojects = enabled
    settings.show_in_scrum_stats = enabled_scrum_stats
    settings.calculate_sprint_name = calculate_sprint_name
    settings.calculate_with_other_project = calculate_with_other_project
    if settings.save
      flash[:notice] = t(:rb_project_settings_updated)
    else
      flash[:error] = t(:rb_project_settings_update_error)
    end
    redirect_to :controller => 'projects', :action => 'settings', :id => @project,
                :tab => 'backlogs'
  end

end
