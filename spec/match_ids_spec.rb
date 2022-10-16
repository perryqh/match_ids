# frozen_string_literal: true

RSpec.describe MatchIds do
  it "has a version number" do
    expect(MatchIds::VERSION).not_to be nil
  end

  context "when has IDs" do
    let(:payload) { { name: "test", fields: [{ id: 3, name: "text" }] } }

    it "has id keys" do
      expect(payload).to have_id_keys
    end

    it "expects error when NOT" do # rubocop:disable RSpec/MultipleExpectations
      expect do
        expect(payload).not_to have_id_keys
      end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                         /to not have ID keys/)
    end

    context "when id is ignored" do
      it "has no id keys" do
        expect(payload).not_to have_id_keys(ignored: [id: { ancestors: [:fields] }])
      end
    end

    context "when has IDs with others ignored" do
      let(:payload) do
        { name: "test",
          fields: [{ id: 3, name: "text" }],
          children: { last: { pretend_id: 55 } } }
      end

      it "expects error when NOT" do # rubocop:disable RSpec/MultipleExpectations
        expect do
          expect(payload).not_to have_id_keys(ignored: [{ pretend_id: { ancestors: %i[children last] } }])
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                           /\[{:id=>{:ancestors=>\[:fields]}}]/)
      end
    end

    describe "ignored IDs" do
      let(:payload) do
        { name: "best burger",
          id: 33,
          franchises: [{ location: "Waco",
                         location_id: 88,
                         menu_additions: [{ name: "secret waco sauce",
                                            id: "sws" }] }] }
      end

      context "when ignored all cases" do
        let(:ignored) do
          [{ id: { ancestors: [] } },
           { location_id: { ancestors: [:franchises] } },
           { id: { ancestors: %i[franchises menu_additions] } }]
        end

        it "finds no IDs" do
          expect(payload).not_to have_id_keys(ignored: ignored)
        end
      end

      context "when ancestors are incomplete" do
        let(:ignored) do
          [{ id: { ancestors: [] } },
           { location_id: { ancestors: [:franchises] } },
           { id: { ancestors: %i[menu_additions] } }]
        end

        it "finds IDs" do
          expect(payload).to have_id_keys(ignored: ignored)
        end
      end

      context "when ancestors are out of order" do
        let(:ignored) do
          [{ id: { ancestors: [] } },
           { location_id: { ancestors: [:franchises] } },
           { id: { ancestors: %i[menu_additions franchises] } }]
        end

        it "finds IDs" do
          expect(payload).to have_id_keys(ignored: ignored)
        end
      end
    end
  end
end
