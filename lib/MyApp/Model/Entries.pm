package MyApp::Model::Entries;
use Mojo::Base -base;
use MyApp::Model::DB;
use Data::Dumper;

has dbh => '';

sub add_entries{
    my ($s, $title,$text,$author) = @_;
	my $sql = 'insert into entries (title, text,author) values (?, ?,?)';
    my $sth = $s->dbh->prepare($sql) or die $s->dbh->errstr;
    if ($sth->execute($title, $text,$author) or die $sth->errstr){
	return 1 ;
	}
	return 0;
}

sub del_entries{
	my($s,$id,$username)=@_;
    my $sql = "delete from entries where id=\'$id\' and author=\'$username\'";
    my $sth = $s->dbh->prepare($sql) or die $s->dbh->errstr;
	if ($sth->execute or die $sth->errstr ){
	return 1 ;
	}
	return 0;
}

sub get_entries{
	my $s = shift;
	my $sql = "select * from entries  limit 10";
	my $sth = $s->dbh->prepare($sql) or die $s->dbh->errstr;
    $sth->execute or die $sth->errstr;
	return $sth->fetchall_hashref('id');
}

sub get_entries_page{
	my ($s,$page)=@_;
	my $sql = 'select * from entries where id >'. ($page-1)*10 .' LIMIT 10';
    my $sth = $s->dbh->prepare($sql) or die $s->dbh->errstr;
       $sth->execute or die $sth->errstr;
	return $sth->fetchall_hashref('id');  
}

1;