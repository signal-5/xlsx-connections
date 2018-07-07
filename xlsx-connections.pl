#!/usr/bin/perl

die "Need site\n" if @ARGV!=1;

$nextPage=1;
$totalResults=2;
$site=$ARGV[0];
# Get your cx here: https://cse.google.com/all
$cx=YOUR_CX;
# Get your key here: https://developers.google.com/custom-search/json-api/v1/introduction#identify_your_application_to_google_with_api_key 
$key=YOUR_KEY;

while($nextPage<92 and $totalResults>$nextPage) {
  $search=`wget -qO- "https://www.googleapis.com/customsearch/v1?key=$key&q=ext%3Axlsx+site%3A$site&cx=$cx&filter=0&start=$nextPage"`;
  (@lines)=$search=~/\"link\": \"([^\"]+)\",/gs;
  ($nextPage)=$search=~/\"nextPage\": .*?\"startIndex\": (\d+),/s;
  ($totalResults)=$search=~/\"totalResults\": \"(\d+)\",/s;
  # Add for debugging:
  # print "$nextPage, $totalResults, @lines\n";

  foreach $URL (@lines) {
    $URL=~s/'/\%27/g;
    $sURL="'" . $URL . "'";
    $result=`wget -qO- $sURL | bsdtar -tf- | grep connections && echo $sURL`;
    # Replace for debugging:
    # $result=`wget -qO- $sURL | bsdtar -tf- | grep connections ; echo $sURL`;
    print $result;
  }

}
