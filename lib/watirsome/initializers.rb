module Watirsome
  module Initializers

    #
    # Initializes page class.
    # Allows to define "#initialize_page" which will be called as page constructor.
    # After page is initialized, iterates through region and initialize each of them.
    #
    def initialize(browser)
      @browser = browser
      initialize_page if respond_to?(:initialize_page)
      initialize_regions
    end

    #
    # Iterates through definitions of "#initialize_region", thus implementing
    # polymorphic Ruby modules (i.e. page regions).
    #
    # Only works with modules matching "Watirsome.region_matcher" regexp.
    # @see Watirsome.region_matcher
    #
    def initialize_regions
      # regions cacher
      @initialized_regions ||= []
      # get included and extended modules
      modules = self.class.included_modules + (class << self; self end).included_modules
      modules.uniq!
      # initialize each module
      modules.each do |m|
        # check that constructor is defined and we haven't called it before
        if !@initialized_regions.include?(m) && m.instance_methods.include?(:initialize_region)
          m.instance_method(:initialize_region).bind(self).call
          # cache region
          @initialized_regions << m
        end
      end
    end

  end # Initializers
end # Watirsome
