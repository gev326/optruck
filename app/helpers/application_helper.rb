module ApplicationHelper
  def humanize_boolean(boolean)
    I18n.t((!!boolean).to_s)
  end

  def us_states
    CS.states(:us)
  end

  def self.cities(state)
    state = state.downcase.to_sym
    CS.cities(state, :us)
  end
end
