use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin . '/../../lib/';
use MUtil::CommandOption;
use Test::More qw(no_plan);

foreach ((
	sub {
		my $result = 0;
		MUtil::CommandOption::_apply_command(
				'2011',
				qr/(^\d+$)/,
				sub { $result = shift;}
			);
		is ( $result, '2011' );
	},
	sub {
		my ($YYYY, $MM, $DD);
		my $option = new MUtil::CommandOption();
		$option->set_argv("2011-10-30");
		$option->bind(
			qr/(\d{4})[\-\/]?(\d{2})[\-\/]?(\d{2})/ => 
				sub {
					$YYYY = shift;
					$MM = shift;
					$DD = shift;
				}
		)->read();
		is ($YYYY, '2011');
		is ($MM, '10');
		is ($DD, '30');
	}
)){ $_->(); }
