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
      expect(finder.error_message)
        .to match(/Expected not to find the following ID keys/)
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
  end

  RSpec.shared_examples "no ids present" do
    it "has no error message" do
      expect(finder.error_message).to be_nil
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
