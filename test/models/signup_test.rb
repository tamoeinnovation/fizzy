require "test_helper"

class SignupTest < ActiveSupport::TestCase
  test "validates email format for identity creation" do
    signup = Signup.new(email_address: "not-an-email")
    assert_not signup.valid?(:identity_creation)
    assert signup.errors[:email_address].any?

    signup = Signup.new(email_address: "valid@example.com")
    assert signup.valid?(:identity_creation)
  end

  test "validates email domain when ALLOWED_EMAIL_DOMAINS is set" do
    with_env("ALLOWED_EMAIL_DOMAINS", "example.com,test.com") do
      signup_allowed = Signup.new(email_address: "user@example.com")
      assert signup_allowed.valid?(:identity_creation)

      signup_allowed_case = Signup.new(email_address: "user@EXAMPLE.COM")
      assert signup_allowed_case.valid?(:identity_creation)

      signup_disallowed = Signup.new(email_address: "user@notallowed.com")
      assert_not signup_disallowed.valid?(:identity_creation)
      assert signup_disallowed.errors[:email_address].any?
      assert_includes signup_disallowed.errors[:email_address], "domain is not allowed to sign up"
    end
  end

  test "allows any email domain when ALLOWED_EMAIL_DOMAINS is not set" do
    with_env("ALLOWED_EMAIL_DOMAINS", nil) do
      signup = Signup.new(email_address: "user@anydomain.com")
      assert signup.valid?(:identity_creation)
    end
  end

  test "allows any email domain when ALLOWED_EMAIL_DOMAINS is empty" do
    with_env("ALLOWED_EMAIL_DOMAINS", "") do
      signup = Signup.new(email_address: "user@anydomain.com")
      assert signup.valid?(:identity_creation)
    end
  end

  test "#create_identity" do
    signup = Signup.new(email_address: "brian@example.com")

    magic_link = nil
    assert_difference -> { Identity.count }, 1 do
      assert_difference -> { MagicLink.count }, 1 do
        magic_link = signup.create_identity
      end
    end

    assert_kind_of MagicLink, magic_link
    assert_empty signup.errors
    assert signup.identity
    assert signup.identity.persisted?

    signup_existing = Signup.new(email_address: "brian@example.com")

    assert_no_difference -> { Identity.count } do
      assert_difference -> { MagicLink.count }, 1 do
        magic_link = signup_existing.create_identity
      end
    end

    assert_kind_of MagicLink, magic_link

    signup_invalid = Signup.new(email_address: "")
    assert_raises do
      signup_invalid.create_identity
    end
  end

  test "#complete" do
    Account.any_instance.expects(:setup_customer_template).once

    Current.without_account do
      signup = Signup.new(full_name: "Kevin", identity: identities(:kevin))

      assert signup.complete

      assert signup.account
      assert signup.user
      assert_equal "Kevin", signup.user.name

      signup_invalid = Signup.new(
        full_name: "",
        identity: identities(:kevin)
      )
      assert_not signup_invalid.complete
      assert_not_empty signup_invalid.errors[:full_name]
    end
  end

  test "#complete with invalid data" do
    Current.without_account do
      signup = Signup.new
      assert_not signup.complete
      assert signup.errors[:full_name].any?
      assert signup.errors[:identity].any?
      assert_nil signup.account
      assert_nil signup.user
    end
  end
end
