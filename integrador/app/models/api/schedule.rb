class Api::Schedule < Api::Base

  def self.show(token, course_id, group, semester)
    return [] if token.blank? or course_id.blank? or group.blank? or semester.blank?
    request = get("/pa/courses/#{course_id}/schedule", :query => { :token => token, :group => group, :semester => semester })
    request["pa"]["programacion"]["evaluacion"]
  end
end
