# Testing Styles

## Feature Testing
Some examples of how to feature test different parts of the application.

###Example 1
Requirement: User data is pre-populated on the form, unless they have
been to the form before in which it will use the data the user manually
entered previously.

```ruby
feature 'user can see correct data inside the fields' do
  let(:user) do
    create(:user, {
      first_name: 'ben',
      last_name: 'robinson'
      email: 'ben@example.com'
    })
  end

  context 'user is signed in' do
    before do
      sign_in(user)
      visit page_with_form
    end

    scenario 'user information is used when no previous session data is found' do
      expect(page).to have_field('#first_name', value: 'ben')
      expect(page).to have_field('#last_name', value: 'robinson')
      expect(page).to have_field('#email', value: 'ben@example.com')
    end

    scenario 'previous session data is used as priority over user information' do
      fill_in('#first_name', with: 'Not Ben')
      fill_in('#last_name', with: 'Not Robinson')
      fill_in('#email', with: 'notben@example.com')

      submit_form

      visit page_with_form

      expect(page).to have_field('#first_name', value: 'Not Ben')
      expect(page).to have_field('#last_name', value: 'Not Robinson')
      expect(page).to have_field('#email', value: 'notben@example.com')
    end
  end

  context 'user is not signed in' do
    background { visit page_with_form }

    scenario 'previous session data will be used if any is found'
      # Assert the fields are empty of have placeholders.
      expect(page).to have_field('#first_name', value: '')
      expect(page).to have_field('#last_name', value: '')
      expect(page).to have_field('#email', value: '')

      fill_in('#first_name', with: 'Not Ben')
      fill_in('#last_name', with: 'Not Robinson')
      fill_in('#email', with: 'notben@example.com')

      submit_form

      visit page_with_form

      expect(page).to have_field('#first_name', value: 'Not Ben')
      expect(page).to have_field('#last_name', value: 'Not Robinson')
      expect(page).to have_field('#email', value: 'notben@example.com')
    end
  end
end
```
The above test tells us all the important information we need to cover.
- What should be present with a user.
- What is present when the user has session data.
- Are the forms empty with no user
- Do they have session data when the form is revisited with no user.


The value asserted agains can either be explict like we use above or
can use the object itself EG:
```ruby
expect(page).to have_field('#first_name', value: user.first_name)
expect(page).to have_field('#last_name', value: user.last_name)
expect(page).to have_field('#email', value: user.email)
```
