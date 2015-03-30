require 'rails_helper'

describe Middleware::Domains do
  let(:middleware) { Middleware::Domains.new({}) }
  describe '#sanitize' do
    subject { middleware.sanitize(url) }
    let(:url) { 'http://www.developmentbootcamp.nl' }
    it { should eq url }

    describe 'with path' do
      let(:url) { 'http://www.developmentbootcamp.nl/some/path/that-we-don-t-care-exists' }
      it { should eq url }
    end

    describe 'naked domain' do
      let(:url) { 'http://developmentbootcamp.nl/some/path/that-we-don-t-care-exists' }
      it { should eq 'http://www.developmentbootcamp.nl/some/path/that-we-don-t-care-exists' }
    end

    describe 'with .eu host' do
      let(:url) { 'http://www.developmentbootcamp.eu/some/path/that-we-don-t-care-exists' }
      it { should eq 'http://www.developmentbootcamp.nl/some/path/that-we-don-t-care-exists' }

      describe 'and naked domain' do
        let(:url) { 'http://developmentbootcamp.eu/some/path/that-we-don-t-care-exists' }
        it { should eq 'http://www.developmentbootcamp.nl/some/path/that-we-don-t-care-exists' }
      end
    end

    describe 'on a .dev host' do
      let(:url) { 'http://developmentbootcamp.nl.dev/some/path/that-we-don-t-care-exists' }
      it { should eq 'http://www.developmentbootcamp.nl.dev/some/path/that-we-don-t-care-exists' }

      describe 'and a custom port' do
        let(:url) { 'http://developmentbootcamp.nl.dev:3000/some/path/that-we-don-t-care-exists' }
        it { should eq 'http://www.developmentbootcamp.nl.dev:3000/some/path/that-we-don-t-care-exists' }
      end
    end

    describe 'on localhost' do
      let(:url) { 'http://localhost/some/path/that-we-don-t-care-exists' }
      it { should eq url }

      describe 'and a custom port' do
        let(:url) { 'http://localhost:5000/some/path/that-we-don-t-care-exists' }
        it { should eq 'http://localhost:5000/some/path/that-we-don-t-care-exists' }
      end
    end
  end
end
