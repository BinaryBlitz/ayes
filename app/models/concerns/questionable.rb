module Questionable
  extend ActiveSupport::Concern

  included do
    extend Enumerize

    enumerize :gender, in: [:male, :female]
    enumerize :country, in: ISO3166::Data.codes + ['WORLD']
    enumerize :region, in: ISO3166::Country.new('RU').subdivisions.keys
    enumerize :occupation,
              in: [
                :businessman, :top_manager, :middle_manager, :engineer,
                :worker, :civil_servant, :student, :pensioner, :unemployed
              ]
    enumerize :income,
              in: [
                :none, :over0, :over10000, :over30000, :over60000,
                :over80000, :over100000, :over130000, :over160000
              ]
    enumerize :education,
              in: [
                :lower_secondary, :upper_secondary, :incomplete_higher,
                :higher, :vocational, :academic
              ]
    enumerize :relationship, in: [:single, :married, :divorced, :civil_union, :widow]
    enumerize :settlement, in: [:village, :urban_village, :town, :city, :million_city]
  end
end
