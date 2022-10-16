# frozen_string_literal: true

require "spec_helper"

RSpec.describe MatchIds::IdFinder do
  subject(:finder) do
    described_class.new(payload, ignored: ignored)
  end

  let(:ignored) { nil }

  context "with IDs" do
    let(:payload) do
      { id: "foo",
        location_id: "bar",
        name: "ok",
        subs: [{ id: "taco",
                 name: "bar" }],
        perfect_ids: [1, 2, 3],
        tesla: [
          { id: true,
            holly: "blue",
            package: { name: "performance",
                       package_id: "bx" } }
        ] }
    end

    it "finds nested keys" do
      expect(finder.nested_keys)
        .to eq([{ id: { ancestors: [] } },
                { location_id: { ancestors: [] } },
                { name: { ancestors: [] } },
                { subs: { ancestors: [] } },
                { id: { ancestors: [:subs] } },
                { name: { ancestors: [:subs] } },
                { perfect_ids: { ancestors: [] } },
                { tesla: { ancestors: [] } },
                { id: { ancestors: [:tesla] } },
                { holly: { ancestors: [:tesla] } },
                { package: { ancestors: [:tesla] } },
                { name: { ancestors: %i[tesla package] } },
                { package_id: { ancestors: %i[tesla package] } }])
    end

    it "finds id keys" do
      expect(finder.id_keys)
        .to eq([{ id: { ancestors: [] } },
                { location_id: { ancestors: [] } },
                { id: { ancestors: [:subs] } },
                { perfect_ids: { ancestors: [] } },
                { id: { ancestors: [:tesla] } },
                { package_id: { ancestors: %i[tesla package] } }])
    end

    it "builds error message" do
      expect(finder.ids_found_error_message)
        .to match(/to not have ID keys/)
    end

    context "when ignoring subs id" do
      let(:ignored) do
        [id: { ancestors: [:subs] }]
      end

      it "finds id keys" do
        expect(finder.id_keys)
          .to eq([{ id: { ancestors: [] } },
                  { location_id: { ancestors: [] } },
                  { perfect_ids: { ancestors: [] } },
                  { id: { ancestors: [:tesla] } },
                  { package_id: { ancestors: %i[tesla package] } }])
      end
    end

    context "with all types of ids" do
      let(:payload) do
        { id: "foo",
          location_id: "bar",
          somethings_ids: "ok" }
      end

      it "finds id keys" do
        expect(finder.id_keys)
          .to eq([{ id: { ancestors: [] } },
                  { location_id: { ancestors: [] } },
                  { somethings_ids: { ancestors: [] } }])
      end
    end
  end

  context "a payload with ids" do
    let(:payload) do
      { id: 3,
        name: "Test",
        location_id: 44,
        foo: { id: 8 } }
    end

    it "contains IDs" do
      expect(payload).to have_id_keys
    end

    it "contains no unexpected IDs" do
      expect(payload)
        .not_to have_id_keys(ignored: [{ id: { ancestors: [] } },
                                       { location_id: { ancestors: [] } },
                                       { id: { ancestors: [:foo] } }])
    end
  end

  RSpec.shared_examples "no ids present" do
    it "has no error message" do
      expect(finder.ids_found_error_message).to be_nil
    end

    it "has no ID keys" do
      expect(finder.id_keys).to be_empty
    end
  end

  context "with nil payload" do
    let(:payload) { nil }

    it_behaves_like "no ids present"
  end

  context "with empty array payload" do
    let(:payload) { [] }

    it_behaves_like "no ids present"
  end

  context "with empty hash payload" do
    let(:payload) { {} }

    it_behaves_like "no ids present"
  end

  context "with no IDs" do
    let(:payload) do
      { od: "foo",
        location_od: "bar",
        name: "ok",
        subs: [{ od: "taco",
                 name: "bar" }] }
    end

    it_behaves_like "no ids present"
  end
end
