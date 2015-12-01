require 'rails_helper'

describe 'frontend routes', type: :routing do
  describe 'root_path' do
    it 'routes to static_pages#home' do
      expect(get: '/').to route_to(
        controller: 'static_pages',
        action: 'home'
      )
    end
  end

  describe 'courses_path' do
    it 'routes to programs#index' do
      expect(get: '/program').to route_to(
        controller: 'programs',
        action: 'index'
      )
    end
    it 'routes to programs#level_one' do
      expect(get: '/program/level-1').to route_to(
        controller: 'programs',
        action: 'level_one'
      )
    end

    it 'routes to programs#level_two' do
      expect(get: '/program/level-2').to route_to(
        controller: 'programs',
        action: 'level_two'
      )
    end

    it 'routes to programs#level_three' do
      expect(get: '/program/level-3').to route_to(
        controller: 'programs',
        action: 'level_three'
      )
    end
    it 'routes to programs#level_four' do
      expect(get: '/program/level-4').to route_to(
        controller: 'programs',
        action: 'level_four'
      )
    end
  end

  describe 'enroll_path' do
    it 'routes to orders#new' do
      expect(get: '/tickets').to route_to(
        controller: 'orders',
        action: 'new'
      )
    end

    it 'routes to orders#create' do
      expect(post: '/tickets').to route_to(
        controller: 'orders',
        action: 'create'
      )
    end

    it 'routes to orders#show' do
      expect(get: '/tickets/1').to route_to(
        controller: 'orders',
        action: 'show',
        id: '1'
      )
    end

    it 'routes to orders#thanks' do
      expect(get: '/tickets/1/thanks').to route_to(
        controller: 'orders',
        action: 'thanks',
        id: '1'
      )
    end

    it 'routes to orders#webhook' do
      expect(post: '/tickets/webhook').to route_to(
        controller: 'orders',
        action: 'webhook'
      )
    end
  end

  describe 'team_path' do
    it 'routes to static_pages#team' do
      expect(get: '/team').to route_to(
        controller: 'static_pages',
        action: 'team'
      )
    end
  end

  describe 'sitemap_path' do
    it 'routes to application#sitemap' do
      expect(get: '/sitemap.xml').to route_to(
        controller: 'application',
        action: 'sitemap',
        format: 'xml'
      )
    end

    it 'routes does not route other formats than xml' do
      expect(get: '/sitemap').to_not be_routable
      expect(get: '/sitemap.json').to_not be_routable
    end
  end
end

