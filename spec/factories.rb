FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Person #{n}"}
		sequence(:email) { |n| "person_#{n}@domain.com"}
		sequence(:city) { |n| "city #{n}"}
		state "Texas"
		job_title "some job"
		company_or_organization "some company"
		password "foobar"
		password_confirmation "foobar"

		factory :admin do
			admin true
		end
	end

	
end
	
		