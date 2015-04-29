# grep subs
#

use strict;
use warnings;

use v5.10;

use Cwd;
use Data::Dumper;
use FileHandle;
use File::Find;

use lib '/storage/emulated/legacy/CCTools/Perl/CPAN/lib';
use lib 'e:/user/peine/prj/my_cpan/lib';

use Scalar::Validation qw(:all);

# --- handle call args and configuration ----
my $config_file = par configuration => -Default => './android.cfg.pl' => ExistingFile => shift;

require $config_file;

my $config = MyConfig::get();

my $perl_meta_db_file = npar -perl_meta_db_file =>              ExistingFile => $config;
my $cpan_lib_path     = npar -cpan_lib_path     => -Optional => Filled       => $config;
my $perl_lib_path     = npar -perl_lib_path     => -Optional => Filled       => $config;

# my $perl_lib_path = 'c:/Strawberry/perl/lib/';
# my $cpan_lib_path = 'c:/Strawberry/perl/site/lib/';

# my $dump_db_file_name = '/storage/emulated/legacy/perl_sw/tools/perl_meta_dump.pl.dump';
# my $dump_db_file_name = 'e:/user/peine/prj/my_cpan/ide/perl_meta_dump.pl.dump';

use Report::Porf qw(:all);
use Scalar::Validation qw(:all);
use PQL::Cache qw (:all);

my @paths = map {$_ ? $_:()}  (
    $cpan_lib_path,
    $perl_lib_path,
);

# while (my $path = shift) {
#     unless (-d $path) {
#         warn "skip not existing directory $path";
#         next;
#     }
#     push(@paths, $path);
# }

my $class_to_search = shift || "GoldenBigMath";

my $meta_infos = new PQL::Cache;

$meta_infos->set_table_definition(
    class =>{
        keys => [qw(ID fullname)],
        columns => [qw(namespace classname filename line_nbr)]
    }
);

my $next_class_id  = 1;
my $next_method_id = 1;

$meta_infos->set_table_definition(
    method =>{
        keys => [qw(ID name)],
        columns => [qw(class_ID line_nbr)]
    }
);

sub scan_file {
    my $file = par PerlFile => ExistingFile => shift;
    
    # say "# --- scan $file ---";
    
    my $fh = new FileHandle();
    my $full_file_name = $File::Find::name;
    
    return unless $fh->open($full_file_name);
    
    my $full_class;
    my $current_class_id = 1;
    my $line;
    my $class_meta_info;
    
    $full_file_name =~ s{.*/CCTools/Perl/CPAN/}{{CPAN}/}io;
    while (my $line = <$fh>) {
        $line =~ s/\s+$//o;
        if ($line =~ /package\s+([\w:]+);/) {
            $full_class = $1;
            # say "class $full_class";
            
            my $namespace  = "";
            my $class_name = $full_class;
            
            if ($full_class =~ /(.*)::(\w+)$/) {
                $namespace  = $1;
                $class_name = $2;
            }
            $current_class_id = $next_class_id++;
            $class_meta_info = {
                    ID        => $current_class_id,
                    fullname  => $full_class,
                    filename  => $full_file_name,
                    namespace => $namespace,
                    classname => $class_name,
                    line_nbr  => $.,
                    line      => $line,
                    subs     => {},
                };
            $meta_infos->insert(class => 
                $class_meta_info
            );
        }
        elsif ($line =~ /sub\s+([\w]+)(.*)/){
            my $sub_name = $1;
            my $sub_rest_of_line = $2;
            
            my $current_method_id = $next_method_id++;
            my $method_meta_info = {
                    ID       => $current_method_id,
                    name     => $sub_name,
                    class_ID => $current_class_id,
                    line_nbr => $.,
                    line     => $line,
                };
                
            $class_meta_info->{subs}->{$sub_name} = $method_meta_info if $class_meta_info;
            $meta_infos->insert(method => 
                $method_meta_info
            );

        # $meta_infos->{$doc_class_name}->{subs}->{$doc_class_method} = {};
        }
    }
    
    # say "# --- done ---";
}

sub join_class_to_method {
    my $method_list     = par method_list => ArrayRef => shift;
    
    my %class_ids_hash = map { $_->{class_ID} ? ($_->{class_ID} => 1) : (1 => 1); } @$method_list;
        
    my @class_ids = sort keys %class_ids_hash;
    # say "# class Ids @class_ids";
        
    my $class_infos_selection = $meta_infos->select(
        what  => [qw(ID fullname)],
        from  => 'class',
        where => [ ID => {in => [@class_ids] }
        ],
    );
    
    # auto_report($class_infos_selection);
    
    my %class_infos = map { $_->{ID} => $_; } @$class_infos_selection;
        
    foreach my $method_info (@$method_list) {
        my $class_id = delete $method_info->{class_ID} || "1";
        my $class_info_ref = $class_infos{$class_id};
        
        $method_info->{class} 
            = $class_info_ref
            ? $class_info_ref->{fullname}
            : "?$class_id";
    }
    
    return $method_list;
}

sub join_by_class_id {
    my $methods_of_class   = par method_list => ArrayRef => shift;
    my $class_to_get_infos = par class_info  => HashRef  => shift;
    
    my $class_name = $class_to_get_infos->{fullname};
    foreach my $method_info (@$methods_of_class) {
        my $class_id = delete $method_info->{class_ID};
        $method_info->{class} = $class_name;
    }
}

say '';
say '# --- start scan for classes and methods -----------------------';
say '';

$meta_infos->insert(class => {
                        ID        => $next_class_id++,
                        fullname  => 'main',
                        filename  => '',
                        namespace => '',
                        classname => 'main',
                        line_nbr  => '',
                        line      => '',
                        subs     => {},
                }
);

say '# --- dirs to scan recursive ------------------------------------';
say '';

foreach (@paths) { say };

say '';
say '# --- start scan ---';
say '';

find( sub {
    if (-d $_) {
       say "# --- scan dir $_ ---";
    }
    elsif (/\.pm$/i) {
        scan_file($_);
    }
}, @paths);
                
my $class_meta_infos = $meta_infos->select(
                what => all    =>
                from => 'class',
                );

my $method_meta_infos = $meta_infos->select(
                what => all    =>
                from => 'method',
                );

say '# ' . $#$class_meta_infos  . ' classes found.';
say '# ' . $#$method_meta_infos . ' methods found.';

say "# Dump DB into file $perl_meta_db_file ...";
my $fh = new FileHandle(">$perl_meta_db_file");
print $fh "package PerlMeta;\nsub load_cache {\n my ";
print $fh Dumper($meta_infos);
print $fh "}\n1;\n";
close $fh;
                    
say '# === All done. ========================';