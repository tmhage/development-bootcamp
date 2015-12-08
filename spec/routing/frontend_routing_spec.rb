require 'rails_helper'

describe 'frontend routes', type: :routing do
  describe 'root_path' do
    it 'routes to static_pages#home' do
      expect(get: '/').to route_to(
        controller: 'static_pages',
        action: 'home',
        locale: 'en'
      )
    end
  end

  describe 'courses_path' do
    it 'routes to courses#index' do
      expect(get: '/courses').to route_to(
        controller: 'programs',
        action: 'index',
        locale: 'en'
      )
    end
    it 'routes to courses#level_one' do
      expect(get: '/courses/beginner-bootcamp').to route_to(
        controller: 'programs',
        action: 'level_one',
        locale: 'en'
      )
    end

    it 'routes to courses#level_two' do
      expect(get: '/courses/intermediate-bootcamp').to route_to(
        controller: 'programs',
        action: 'level_two',
        locale: 'en'
      )
    end

    it 'routes to courses#level_three' do
      expect(get: '/courses/advanced-bootcamp').to route_to(
        controller: 'programs',
        action: 'level_three',
        locale: 'en'
      )
    end
  end

  describe 'enroll_path' do
    it 'routes to orders#new' do
      expect(get: '/enroll').to route_to(
        controller: 'orders',
        action: 'new',
        locale: 'en'
      )
    end

    it 'routes to orders#create' do
      expect(post: '/enroll').to route_to(
        controller: 'orders',
        action: 'create',
        locale: 'en'
      )
    end

    it 'routes to orders#show' do
      expect(get: '/enroll/1').to route_to(
        controller: 'orders',
        action: 'show',
        id: '1',
        locale: 'en'
      )
    end

    it 'routes to orders#thanks' do
      expect(get: '/enroll/1/thanks').to route_to(
        controller: 'orders',
        action: 'thanks',
        id: '1',
        locale: 'en'
      )
    end

    it 'routes to orders#webhook' do
      expect(post: '/enroll/webhook').to route_to(
        controller: 'orders',
        action: 'webhook',
        locale: 'en'
      )
    end
  end

  describe 'team_path' do
    it 'routes to static_pages#team' do
      expect(get: '/team').to route_to(
        controller: 'static_pages',
        action: 'team',
        locale: 'en'
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
          id: 'foobar',
          locale: 'en'
        )
      end
    end
  end

  describe 'sitemap_path' do
    it 'routes to application#sitemap' do
      expect(get: '/sitemap.xml').to route_to(
        controller: 'application',
        action: 'sitemap',
        format: 'xml',
        locale: 'en'
      )
    end

    it 'routes does not route other formats than xml' do
      expect(get: '/sitemap').to_not be_routable
      expect(get: '/sitemap.json').to_not be_routable
    end
  end
end

