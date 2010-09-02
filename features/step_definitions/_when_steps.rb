When /^I create the story$/ do
  page.driver.process :post, 
                      url_for(:controller => :rb_stories, :action => :create),
                      @story_params
end

When /^I create the task$/ do
  page.driver.process :post, 
                      url_for(:controller => :rb_tasks),
                      @task_params
end

When /^I move the story named (.+) to the (\d+)(?:st|nd|rd|th) position of the sprint named (.+)$/ do |story_subject, position, sprint_name|
  position = position.to_i
  story = Story.find(:first, :conditions => "subject='#{story_subject}'")
  sprint = Sprint.find(:first, :conditions => "name='#{sprint_name}'")
  story.fixed_version = sprint

  attributes = story.attributes
  attributes[:prev] = if position == 1
                        ''
                      else
                        stories = Story.find(:all, :conditions => "fixed_version_id=#{sprint.id}", :order => "position ASC")
                        stories[position-2].id
                      end

  page.driver.process :post,
                      url_for(:controller => 'stories', :action => 'update'),
                      attributes
end

When /^I move the (\d+)(?:st|nd|rd|th) story to the (\d+|last)(?:st|nd|rd|th)? position$/ do |old_pos, new_pos|
  @story_ids = page.all(:css, "#product_backlog .stories .story .id")

  story = @story_ids[old_pos.to_i-1]
  story.should_not == nil

  prev = if new_pos.to_i == 1
           nil
         elsif new_pos=='last'
           @story_ids.last
         elsif old_pos.to_i > new_pos.to_i
           @story_ids[new_pos.to_i-2]
         else
           @story_ids[new_pos.to_i-1]
         end

  page.driver.process :post, 
                      url_for(:controller => :rb_stories, :action => :update, :id => story.text),
                      {:prev => (prev.nil? ? '' : prev.text), :project_id => @project.id, "_method" => "put"}

  @story = Story.find(story.text.to_i)
end

When /^I request the server_variables resource$/ do
  visit url_for(:controller => :rb_server_variables, :action => :show, :id => @project.id)
end

When /^I update the sprint$/ do
  page.driver.process :post,
                      url_for(:controller => 'backlogs', :action => 'update'),
                      @sprint_params
end

When /^I update the story$/ do
  page.driver.process :post,
                      url_for(:controller => :rb_stories, :action => :update, :id => @story_params[:id]),
                      @story_params
  page.driver.response.status.should == 200
end

When /^I download the calendar feed$/ do
  visit url_for({ :key => @user.api_key, :controller => 'backlogs', :action => 'calendar', :format => 'xml', :project_id => @project.id })
end

When /^I view the stories of (.+) in the issues tab/ do |sprint_name|
  sprint = Sprint.find(:first, :conditions => "name='#{sprint_name}'")
  visit url_for(:controller => :rb_queries, :action => :show, :id => sprint.project_id, :sprint_id => sprint.id)
end

When /^I view the stories in the issues tab/ do
  visit url_for(:controller => :rb_queries, :action => :show, :id=> @project.id)
end

When /^I download the product backlog cards$/ do
  visit url_for(:controller => 'backlogs', :action => 'product_backlog_cards', :project_id => @project.id)
end

When /^I download the task board cards$/ do
  visit url_for(:controller => 'backlogs', :action => 'taskboard_cards', :sprint_id => @sprint.id, :project_id => @project.id)
end

When /^I have selected card label stock "([^"]+)"$/ do |stock|
  Setting.plugin_redmine_backlogs[:card_spec] = stock
end

When /^I view the sprint notes$/ do
  visit url_for(:controller => 'backlogs', :action => 'wiki_page', :sprint_id => @sprint.id, :project_id => @project.id)
  page.driver.response.status.should == 200
end

When /^I edit the sprint notes$/ do
  visit url_for(:controller => 'backlogs', :action => 'wiki_page_edit', :sprint_id => @sprint.id, :project_id => @project.id)
  page.driver.response.status.should == 200
end
