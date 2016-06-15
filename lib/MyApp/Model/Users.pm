package MyApp::Model::Users;
use Mojo::Base -base;

has dbh =>  '';

sub is_user{
    my ($s, $username) = @_;
    my $sql = "select * from users where name=\'$username\' limit 1";
    my $sth = $s->dbh->prepare($sql) or die $s->dbh->errstr;
       $sth->execute or die $sth->errstr;
    if (my @row = $sth->fetchrow_array()){
		return 1 ;
		}
		return 0;
}
sub check_user_pass{
	my ($s, $username,$password) = @_;
    my $sql = "select * from users where name=\'$username\' and password=\'$password\' limit 1";
    my $sth = $s->dbh->prepare($sql) or die $s->dbh->errstr;
       $sth->execute or die $sth->errstr;
	if (my @row = $sth->fetchrow_array()){
		return 1;
		} else {
		return 0;
		} 
}

sub is_author{
	my($s,$id,$username)=@_;
	my $sql = "select * from entries  where id=\'$id\' and author=\'$username\' limit 1";
	my $sth = $s->dbh->prepare($sql) or die $s->dbh->errstr;
       $sth->execute or die $sth->errstr;
	if (my @row = $sth->fetchrow_array()){
	    return 1 ;
	    }
		return 0;
}

sub del_aricle{
	my($s,$id,$username)=@_;
    my $sql = "delete from entries where id=\'$id\' and author=\'$username\'";
    my $sth = $$s->dbh->prepare($sql) or die $s->dbh->errstr;
    $sth->execute or die $sth->errstr;

}

1;