use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile (
	       'NAME'	      =>   'WWW::Overture::Keywords',
	       'AUTHOR'        =>  'Ashish Gulhati <agul@cpan.org>',
	       'ABSTRACT_FROM' =>  'Keywords.pm',
	       'VERSION_FROM'  =>  'Keywords.pm',
	       'PREREQ_PM'     =>  {
				    'Carp'            => 0,
				    'LWP::UserAgent'  => 0
				   },
	      );
