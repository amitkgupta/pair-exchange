def fake_login_user(user = create(:user))
	session[:google_id] = user.google_id
end

def fake_logged_in_user
	User.find_by_google_id(session[:google_id])
end

def login_test_user
	visit root_path
	fill_in "Email", with: "testing.pair.exchange@gmail.com"
	fill_in "Password", with: "john50buttons"
	find("#PersistentCookie").set(false)
	click_on "Sign in"
	sleep 1.5 and click_on "Allow access" if page.has_content? "Allow access"
end