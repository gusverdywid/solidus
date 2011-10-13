module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the sign in page/
      new_spree_user_session_path
    when /the sign up page/
      new_spree_user_registration_path
    when /the forgot password page/
      new_spree_user_password_path
    when /the admin home page/
      spree_admin_path
    when /my account page/
      '/account'
    when /the admin orders page/
      spree_admin_orders_path
    when /the edit admin order page for (.*)/
      spree_edit_admin_order_path($1)
    when /the show admin order page for (.*)/
      spree_admin_order_path($1)

      # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
