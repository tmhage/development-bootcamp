class CodeExperienceCollection < BaseCollection

  def self.collection
    [
      { name: 'HTML/CSS', id: 'html_css' },
      { name: 'JavaScript', id: 'javascript' },
      { name: 'Backend JavaScript', id: 'backend_js' },
      { name: 'Ruby/Ruby on Rails', id: 'ruby' },
      { name: 'Python', id: 'python' },
      { name: 'PHP', id: 'php' },
      { name: 'SQL/Databases', id: 'sql' },
      { name: 'Bash', id: 'bash' },
      { name: 'Other', id: I18n.t(:label_other) },
      { name: I18n.t(:label_no_experience), id: 'none' }
    ]
  end
end
