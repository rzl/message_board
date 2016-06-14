package MyAppDB;
use Data::Dumper;

my @pool;
my $normalcon=10;

sub conf{return do 'db.conf' };

sub new {
	my $self=shift;
	$self->setcon($normalcon);
	bless {}, $self ;
	
}

sub  connect_db {
  my $self=shift;
  my $dbconf = $self->conf();
  print Dumper($dbconf); 
  my $constr=$dbconf->{driver}.":database=".$dbconf->{database}.";host=".$dbconf->{hostname}.";port=".$dbconf->{port}.";";
  return Schema->connect($constr,$dbconf->{user},$dbconf->{pass}, { mysql_enable_utf8 => 1});
}

sub addcon{
	my $self=shift;
	my $dbh = $self->connect_db(); 
	push @pool,$dbh;
}

sub delcon{
	my $self=shift;
	my $dbh=pop @pool;
	$dbh->disconnect;
}

sub setcon{
    my($c,$num)=@_;
	while($#pool<$num){
	$c->addcon();
	}
	while($#pool>$num){
	$c->delcon();
	}
}
sub setnormalcon{
	shift;
	$normalcon=shift;
}

sub getcon{
	print Dumper($#pool); 
	if ($#pool>0) {
	my $dbh=pop @pool;
	return $dbh;
	} else {
	my $dbh=connect_db();
	return $dbh;
	}
}

sub putcon{
	print Dumper($#pool); 
	my($c,$dbh)=@_;
	if ($#pool>$normalcon) {
	$dbh->disconnect;
	} else {
	push @pool,$dbh;
	}
}

sub getpoolnum{
	return $#pool;
}



1;