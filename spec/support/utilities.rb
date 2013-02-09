def sign_in(user)
  visit signin_path
  fill_in "session_email",    with: user.email
  fill_in "session_password", with: user.password
  click_button "commit"
  # Sign in when not using Capybara as well.
  cookies[:session_token] = user.session_token
end

def sign_out
  visit signout_path
end