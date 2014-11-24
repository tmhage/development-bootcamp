require 'rails_helper'

describe 'frontend routes', type: :routing do
  describe 'root_path' do
    it 'routes to static_pages#about' do
      expect(get: '/').to route_to(
        controller: 'static_pages',
        action: 'about'
      )
    end
  end

  describe 'schedule_path' do
    it 'routes to static_pages#schedule' do
      expect(get: '/schedule').to route_to(
        controller: 'static_pages',
        action: 'schedule'
      )
    end
  end

  describe 'tickets_path' do
    it 'routes to static_pages#tickets' do
      expect(get: '/tickets').to route_to(
        controller: 'static_pages',
        action: 'tickets'
      )
    end
  end

  describe 'blog routing' do
    it 'should route to posts#index' do
      describe 'blog index route' do
        expect(get: '/blog').to route_to(
          controller: 'posts',
          action: 'index'
        )
      end
    end

    describe 'blog post route' do
      it 'should route to posts#show' do
        expect(get: '/blog/foobar').to route_to(
          controller: 'posts',
          action: 'show',
          id: 'foobar'
        )
      end
    end
  end
end
