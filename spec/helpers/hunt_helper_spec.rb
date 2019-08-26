require 'rails_helper'

RSpec.describe HuntHelper do
  let(:user) { create :user }
  let(:rando) { create :user }
  let(:hunt) { create :hunt, owner: user, name: 'Test Hunt', start_time: DateTime.new(2030, 4, 26, 10, 00) }
  let(:team) { create :team, hunt: hunt }
  let(:upcoming_hunt) { create :hunt, owner: user, name: 'Upcoming Hunt', start_time: (DateTime.current + 24.hours).to_datetime }
  let(:upcoming_team) { create :team, hunt: upcoming_hunt }

  context 'given a single hunt' do
    it 'gets the date' do
      text = "<a href=\"/hunts/#{hunt.id}\">Test Hunt</a> | Fri, April 26 at 10:00am - 12:00pm"
      expect(with_date(hunt)).to eq(text)
    end

    it 'gets the date and team' do
      text = "<a href=\"/hunts/#{hunt.id}\">Test Hunt</a> | Fri, April 26 at 10:00am - 12:00pm<br /><a href=\"/hunts/#{hunt.id}/teams/#{team.id}\">#{team.name}</a>"
      expect(with_date_and_team(hunt, team)).to eq(text)
    end

    it 'gets the participants and date' do
      text = "0 Hunters | Test Hunt | Fri, April 26 at 10:00am - 12:00pm"
      expect(with_participants_and_date(hunt)).to eq(text)
    end

    it "creates an li with hunt details" do
      text = "<li><a href=\"/hunts/#{hunt.id}\">Test Hunt</a> | Fri, April 26 at 10:00am - 12:00pm</li>"
      expect(li_for_hunt(:with_date, hunt)).to eq(text)
    end

    it "creates an li with the class upcoming_hunt if the hunt is upcoming" do
      expect(li_for_hunt(:with_date, upcoming_hunt)).to include('<li class="upcoming_hunt">')
    end
  end


  it "displays a list of hunts" do
    display_hunts_text = display_hunts([hunt, upcoming_hunt])
    expect(display_hunts_text).to include(hunt.name)
    expect(display_hunts_text).to include(upcoming_hunt.name)
  end

  context 'Authenticated user owns the hunt' do
    # TODO: add tests later when authtication issue in tests is solved
    it "has edit and delete buttons for pending hunts" do

    end

    it "does not have edit or delete buttons for active and completed hunts" do

    end
  end

  context 'Authenticated user is participating in an active hunt' do
    it "has a link to their teams page" do

    end
  end
end
