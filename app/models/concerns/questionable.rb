module Questionable
  extend ActiveSupport::Concern

  included do
    extend Enumerize

    enumerize :gender, in: [:male, :female], multiple: self == Question
    enumerize :country, in: ISO3166::Data.codes + ['WORLD'] unless self == Question
    enumerize :region, in: ISO3166::Country.new('RU').subdivisions.keys unless self == Question
    enumerize :occupation,
              in: [
                :businessman, :top_manager, :middle_manager, :engineer,
                :worker, :civil_servant, :student, :pensioner, :unemployed
              ], multiple: self == Question
    enumerize :income,
              in: [
                :none, :over0, :over10000, :over30000, :over60000,
                :over80000, :over100000, :over130000, :over160000
              ], multiple: self == Question
    enumerize :education,
              in: [
                :lower_secondary, :upper_secondary, :incomplete_higher,
                :higher, :vocational, :academic
              ], multiple: self == Question
    enumerize :relationship, in: [:single, :married, :divorced, :civil_union, :widow], multiple: self == Question
    enumerize :settlement, in: [:village, :urban_village, :town, :city, :million_city, :MOW, :SPE], multiple: self == Question
  end
end
