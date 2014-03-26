require "spec_helper"

describe InviteMailer do
  describe "invite_people" do
    let(:mail) { InviteMailer.invite_people }

    it "renders the headers" do
      mail.subject.should eq("Invite people")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
