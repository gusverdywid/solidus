# class_attributes are inheritied unless you reassign them in
# the subclass, so when you inherit a Preferable class, the
# inherited hook will assign a new hash for the subclass definitions
# and copy all the definitions allowing the subclass to add
# additional defintions without affecting the base
module Spree::Preferences::Preferable

  def self.included(base)
    base.class_eval do
      extend Spree::Preferences::PreferableClassMethods
    end
  end

  def get_preference(name)
    raise NoMethodError.new "#{name} preference not defined" unless has_preference? name
    send "preferred_#{name}".to_sym
  end

  def set_preference(name, value)
    raise NoMethodError.new "#{name} preference not defined" unless has_preference? name
    send "preferred_#{name}=".to_sym, value
  end

  def preference_type(name)
    send "preferred_#{name}_type".to_sym
  end

  def preference_default(name)
    send "preferred_#{name}_default".to_sym
  end

  def has_preference?(name)
    respond_to? "preferred_#{name}"
  end

  def preferences
    prefs = {}
    methods.grep(/^prefers_.*\?$/).each do |pref_method|
      prefs[pref_method.gsub(/prefers_|\?/, '').to_sym] = send(pref_method)
    end
    prefs
  end

  def prefers?(name)
    get_preference(name)
  end

  def preference_cache_key(name)
    [self.class.name, name, (try(:id) || :new)].join('::').underscore
  end

  private

  def preference_store
    Spree::Preferences::Store.instance
  end

end

