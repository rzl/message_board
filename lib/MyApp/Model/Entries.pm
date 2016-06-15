package MyApp::Model::Entries;
use Mojo::Base -base;
use MyApp::Model::DB;

has dbh => '';

sub add_entries{
    my ($s, $title,$text,$author) = @_;
	my $sql = 'insert into entries (title, text,author) values (?, ?,?)';
    my $sth = $s->dbh->prepare($sql) or die $s->dbh->errstr;
    $sth->execute($title, $text,$author)or die $sth->errstr;
  if ($s->dbh->last_insert_id ge 0){
	return 1 ;
	}
	return 0;
}

sub del_entries{
  my($s,$id,$username)=@_;
  my $sql = "select * from entries  where id=\'$id\' and author=\'$username\' limit 1";
  my $sth = $s->dbh->prepare($sql) or die $s->dbh->errstr;
     $sth->execute or die $sth->errstr;
       if (my @row = $sth->fetchrow_array()){
	       
	       return 1 ;
	    }

	return undef;
}

sub update_entries{
	my($s,$id,$username)=@_;

    my $sql = "delete from entries where id=\'$id\' and author=\'$username\'";
    my $sth = $s->dbh->prepare($sql) or die $s->dbh->errstr;
    $sth->execute or die $sth->errstr;
}

sub get_entries{
	my $s = shift;
	my $sql = "select * from entries  limit 10";
	my $sth = $s->dbh->prepare($sql) or die $s->dbh->errstr;
    $sth->execute or die $sth->errstr;
	return $sth->fetchall_hashref('id');
}


1;