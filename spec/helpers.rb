def fake_login(email)
	session[:email] = email
	session[:google_api_refresh_token] = "refresh_token"
end

def login_test_user
	visit root_path
	fill_in "Email", with: "testing.pair.exchange@gmail.com"
	fill_in "Password", with: "john50buttons"
	click_on "Sign in"
	sleep 3 and click_on "Allow access" if page.has_content? "Allow access"
end