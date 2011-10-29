package MUtil::CommandOption;

use strict;
use warnings;
no strict 'refs';

sub new {
	my $class = shift;
	my $self = {
		ARGV => \@ARGV,
		command_hash => {}
	};

	return bless $self, $class;
}

sub set_argv {
	my ($self, @argv) = @_;

	$self->{ARGV} = \@argv;
	return $self;
}

sub bind {
	my ($self, @commands) = @_;

	my %command_hash = @commands;
	$self->{command_hash} = \%command_hash;
	return $self;
}

sub read {
	my $self = shift;

	while ( my ($regexp, $command) = each ( %{$self->{command_hash}} ) ) {
		foreach ( @{$self->{ARGV}} ) {
			&_apply_command($_, $regexp, $command);
		}
	}

	return $self;
}

sub _apply_command {
	my ( $arg, $regexp, $command ) = @_;
	return 0 unless defined($regexp) || defined($command);
	return 0 unless ref($regexp) eq 'Regexp' || ref($command) eq 'CODE';

	if ( $arg =~ $regexp ) {
		my @matchs = ();
		my $count = 1;
		while ( defined( my $i = ${$count++} ) ) {
			push (@matchs, $i);
		}
		$command->(@matchs);
		return 1;
	}
	return 0;
}

1;
