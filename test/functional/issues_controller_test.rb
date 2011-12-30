# Change More plugin for Redmine
# Copyright (C) 2011 Takashi Takebayashi
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
require File.dirname(__FILE__) + '/../test_helper'
require 'issues_controller'

# Re-raise errors caught by the controller.
class IssuesController; def rescue_action(e) raise e end; end

class IssuesControllerTest < ActionController::TestCase
  include ApplicationHelper
  include ActionView::Helpers::TextHelper

  fixtures :projects,
            :users,
            :roles,
            :members,
            :member_roles,
            :issues,
            :issue_statuses,
            :versions,
            :trackers,
            :projects_trackers,
            :issue_categories,
            :enabled_modules,
            :enumerations,
            :attachments,
            :workflows,
            :custom_fields,
            :custom_values,
            :custom_fields_projects,
            :custom_fields_trackers,
            :time_entries,
            :journals,
            :journal_details,
            :queries,
            :watchers

  def setup
    @controller = IssuesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user_id] = 2
  end

  def a_issue
    assert_difference 'Issue.count' do
      post :create, :project_id => 1,
        :issue => {:tracker_id => 3,
                   :status_id => 1,
                   :subject => 'This is the test_new issue',
                   :description => 'This is the description',
                   :priority_id => 4,
                   :estimated_hours => '',
                   :start_date => Date.today,
                   :due_date => (Date.today + 1),
                   :done_ratio => 50}
    end
  end

  context '#edit' do
    should 'accept get' do
      a_issue
      get :edit, :id => Issue.last.id
      assert_response :success
      assert_template 'edit'
      assert_not_nil assigns(:issue)
      assert_equal Issue.find(Issue.last.id), assigns(:issue)
      assert_select 'a', ::I18n.t(:label_more)
    end
  end
end
