Geocoder.configure(:lookup => :test)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => 52.3650027,
      'longitude'    => 4.903851,
      'address'      => 'Weesperstraat 61, 1018 VN Amsterdam',
      'state'        => 'Noord-Holland',
      'state_code'   => 'NH',
      'country'      => 'The Netherlands',
      'country_code' => 'NL'
    }
  ]
)
