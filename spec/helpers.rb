def fake_login_user(user = friendly_user)
	session[:google_id] = user.google_id
end

def fake_logged_in_user
	User.find_by_google_id(session[:google_id])
end

def login_test_user
	visit root_path
	sign_in if sign_in_necessary?
	allow_access if allow_access_necessary?
end

def sign_in
	fill_in "Email", with: "testing.pair.exchange@gmail.com"
	fill_in "Password", with: "john50buttons"	
	click_on "Sign in"
end

def sign_in_necessary?
	page.has_content? "Sign in"
end

def allow_access
	sleep 1 and click_on "Allow access"
end

def allow_access_necessary?
	page.has_content? "Allow access"
end

def friendly_user
	User.find_by_email('pear.programming@gmail.com') ||
		User.create(email: 'pear.programming@gmail.com', google_id: '116917872107923397489')
end

def loner
	# solo50buttons, Solo Programming
	User.find_by_email('o.solo.mioooo@gmail.com') ||
		User.create(email: 'o.solo.mioooo@gmail.com', google_id: '117952378088929416951')
end

