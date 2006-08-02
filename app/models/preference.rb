class Preference < ActiveRecord::Base
def Preference.get_pref(setting)
    result = Preference.find_by_setting( setting )
    if not result.nil?
      return result["value"]
    end
    return nil
  end
end
