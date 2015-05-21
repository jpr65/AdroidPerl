# perl
#
# Class Report::Porf::Table::Simple
#
# Use Configurator or Framework of namespace Report::Porf to create Instances,
# that export data as text, html, csv, LaTeX, for wikis and Excel
#
# Ralf Peine, Wed May 14 10:39:51 2014
#
# More documentation at the end of file
#------------------------------------------------------------------------------

$VERSION = "2.001";

#------------------------------------------------------------------------------
#
# Easy create lists like this as text, html, csv, ...: 
#
# *============+======================+=========+=======+======================*
# @ Count      @ Prename              @ Surname @ Age   @ TimeStamp            @
# *------------+----------------------+---------+-------+----------------------*
# | 1          | Vorname 1            | Name 1  | 10    | 0.002329             |
# | 2          | Vorname 2            | Name 2  | 20    | 0.003106             |
# | 3          | Vorname 3            | Name 3  | 30    | 0.003822             |
# | 4          | Vorname 4            | Name 4  | 40    | 0.004533             |
# | 5          | Vorname 5            | Name 5  | 50    | 0.005235             |
# | 6          | Vorname 6            | Name 6  | 60    | 0.005944             |
# | 7          | Vorname 7            | Name 7  | 70    | 0.006656             |
# | 8          | Vorname 8            | Name 8  | 80    | 0.007362             |
# | 9          | Vorname 9            | Name 9  | 90    | 0.008069             |
# | 10         | Vorname 10           | Name 10 | 100   | 0.008779             |
# *============+======================+=========+=======+======================*
#
# # Time needed for export of 10 data lines: 0.001954
#
#------------------------------------------------------------------------------

use strict;
use warnings;

#--------------------------------------------------------------------------------
#
#  Report::Porf::Table::Simple;
#
#--------------------------------------------------------------------------------

package Report::Porf::Table::Simple;

use Carp;
use FileHandle;

use Report::Porf::Util;

#--------------------------------------------------------------------------------
#
#  Creation / Filling Of Instances
#
#--------------------------------------------------------------------------------

# --- create Instance -----------------
sub new
{
    my $caller = $_[0];
    my $class  = ref($caller) || $caller;
    
    # let the class go
    my $self = {};
    bless $self, $class;

    $self->_init();
    
    return $self;
}

# --- initialise instance -------------
sub _init {
    my ($self,        # instance_ref
        ) = @_;

    $self->set_default_column_width (0);
    $self->set_max_col_width        (0);
    $self->set_max_column_idx       (-2);
    $self->set_format             ('?');

    $self->set_column_widths_ref([]);
    $self->set_header_texts_ref ([]);
    
    $self->set_file_start  ('');
    $self->set_page_start  ('');
    $self->set_table_start ('');

    $self->set_header_row_start ('');
    $self->set_header_start    ('');
    $self->set_header_end      ('');
    $self->set_header_row_end   ('');

    $self->set_row_start  ('');
    $self->set_cell_start ('');
    $self->set_cell_end   ('');
    $self->set_row_end    ('');

    $self->set_table_end ('');
    $self->set_page_end  ('');
    $self->set_file_end  ('');

    $self->set_default_align ('');

    $self->set_header_line     ('');
    $self->set_separator_line  ('');
    $self->set_bold_header_line ('');

    $self->set_bold    ('');
    $self->set_italics ('');
    $self->set_left    ('');
    $self->set_right   ('');
    $self->set_center  ('');

    $self->set_horizontal_separation_start           ('');
    $self->set_horizontal_separation_end             ('');
    $self->set_horizontal_separation_column_separator ('');
    $self->set_horizontal_separation_char            ('');
    $self->set_horizontal_separation_bold_char        ('');

    # $self->set_configure_column_action   (sub {});
    # $self->set_configure_complete_action (sub {});
    # $self->set_cell_output_action        (sub {});
    # $self->set_header_output_action      (sub {});
    # $self->set_row_output_action         (sub {});
    # $self->set_start_table_output_action  (sub {});
    # $self->set_end_table_output_action    (sub {});
    # $self->set_row_group_changes_action   (sub {});

    $self->set_verbose (0);

    my @CellOutputActions;
    $self->{CellOutputActions} = \@CellOutputActions;
}

#--------------------------------------------------------------------------------
#
#  Attributes
#
#--------------------------------------------------------------------------------

# Generated by peiner from CreateGetSetter.pl at Fri Apr 19 08:27:27 2013

# --- Format ---------------------------------------------------------------

sub set_format {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set Format after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{Format} = $value;
}

sub get_format {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{Format};
}

# --- Check, if given format is used for export ---
sub is_format {
    my ($self,        # instance_ref
        $format       # format to compare with
        ) = @_;
    
    return lc ($self->{Format}) eq lc($format) ? 1: 0;
}

# --- MaxColWidth ---------------------------------------------------------------

sub set_max_col_width {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set MaxColWidth after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{MaxColWidth} = $value;
}

sub get_max_col_width {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{MaxColWidth};
}

# --- DefaultColumnWidth ---------------------------------------------------------------

sub set_default_column_width {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set DefaultColumnWidth after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{DefaultColumnWidth} = $value;
}

sub get_default_column_width {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{DefaultColumnWidth};
}

# --- DefaultAlign ---------------------------------------------------------------

sub set_default_align {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set DefaultAlign after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{DefaultAlign} = $value;
}

sub get_default_align {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{DefaultAlign};
}

# --- MaxColumnIdx ---------------------------------------------------------------

sub set_max_column_idx {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set MaxColumnIdx after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{MaxColumnIdx} = $value;
}

sub get_max_column_idx {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{MaxColumnIdx};
}

# --- ColumnWidthsRef ---------------------------------------------------------------

sub set_column_widths_ref {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set ColumnWidthsRef after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{ColumnWidthsRef} = $value;
}

sub get_column_widths_ref {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{ColumnWidthsRef};
}

# --- HeaderTextsRef ---------------------------------------------------------------

sub set_header_texts_ref {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set HeaderTextsRef after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{HeaderTextsRef} = $value;
}

sub get_header_texts_ref {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{HeaderTextsRef};
}

# --- FileStart ---------------------------------------------------------------

sub set_file_start {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set FileStart after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{FileStart} = $value;
}

sub get_file_start {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{FileStart};
}

# --- FileEnd ---------------------------------------------------------------

sub set_file_end {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set FileEnd after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{FileEnd} = $value;
}

sub get_file_end {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{FileEnd};
}

# --- TableStart ---------------------------------------------------------------

sub set_table_start {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set TableStart after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{TableStart} = $value;
}

sub get_table_start {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{TableStart};
}

# --- TableEnd ---------------------------------------------------------------

sub set_table_end {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set TableEnd after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{TableEnd} = $value;
}

sub get_table_end {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{TableEnd};
}

# --- HeaderRowStart ---------------------------------------------------------------

sub set_header_row_start {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set HeaderRowStart after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{HeaderRowStart} = $value;
}

sub get_header_row_start {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{HeaderRowStart};
}

# --- HeaderRowEnd ---------------------------------------------------------------

sub set_header_row_end {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set HeaderRowEnd after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{HeaderRowEnd} = $value;
}

sub get_header_row_end {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{HeaderRowEnd};
}

# --- PageStart ---------------------------------------------------------------

sub set_page_start {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set PageStart after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{PageStart} = $value;
}

sub get_page_start {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{PageStart};
}

# --- PageEnd ---------------------------------------------------------------

sub set_page_end {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set PageEnd after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{PageEnd} = $value;
}

sub get_page_end {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{PageEnd};
}

# --- RowStart ---------------------------------------------------------------

sub set_row_start {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set RowStart after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{RowStart} = $value;
}

sub get_row_start {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{RowStart};
}

# --- RowEnd ---------------------------------------------------------------

sub set_row_end {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set RowEnd after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{RowEnd} = $value;
}

sub get_row_end {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{RowEnd};
}

# --- HeaderStart ---------------------------------------------------------------

sub set_header_start {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set HeaderStart after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{HeaderStart} = $value;
}

sub get_header_start {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{HeaderStart};
}

# --- HeaderEnd ---------------------------------------------------------------

sub set_header_end {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set HeaderEnd after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{HeaderEnd} = $value;
}

sub get_header_end {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{HeaderEnd};
}

# --- CellStart ---------------------------------------------------------------

sub set_cell_start {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set CellStart after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{CellStart} = $value;
}

sub get_cell_start {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{CellStart};
}

# --- CellEnd ---------------------------------------------------------------

sub set_cell_end {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set CellEnd after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{CellEnd} = $value;
}

sub get_cell_end {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{CellEnd};
}

# --- HeaderLine ---------------------------------------------------------------

sub set_header_line {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set HeaderLine after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{HeaderLine} = $value;
}

sub get_header_line {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{HeaderLine};
}

# --- SeparatorLine ---------------------------------------------------------------

sub set_separator_line {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set SeparatorLine after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{SeparatorLine} = $value;
}

sub get_separator_line {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{SeparatorLine};
}

# --- BoldHeaderLine ---------------------------------------------------------------

sub set_bold_header_line {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set BoldHeaderLine after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{BoldHeaderLine} = $value;
}

sub get_bold_header_line {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{BoldHeaderLine};
}

# --- Bold ---------------------------------------------------------------

sub set_bold {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set Bold after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{Bold} = $value;
}

sub get_bold {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{Bold};
}

# --- Italics ---------------------------------------------------------------

sub set_italics {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set Italics after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{Italics} = $value;
}

sub get_italics {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{Italics};
}

# --- Left ---------------------------------------------------------------

sub set_left {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set Left after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{Left} = $value;
}

sub get_left {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{Left};
}

# --- Right ---------------------------------------------------------------

sub set_right {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set Right after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{Right} = $value;
}

sub get_right {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{Right};
}

# --- Center ---------------------------------------------------------------

sub set_center {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set Center after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{Center} = $value;
}

sub get_center {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{Center};
}

# --- HorizontalSeparationStart ---------------------------------------------------------------

sub set_horizontal_separation_start {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set HorizontalSeparationStart after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{HorizontalSeparationStart} = $value;
}

sub get_horizontal_separation_start {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{HorizontalSeparationStart};
}

# --- HorizontalSeparationEnd ---------------------------------------------------------------

sub set_horizontal_separation_end {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set HorizontalSeparationEnd after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{HorizontalSeparationEnd} = $value;
}

sub get_horizontal_separation_end {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{HorizontalSeparationEnd};
}

# --- HorizontalSeparationColumnSeparator ---------------------------------------------------------------

sub set_horizontal_separation_column_separator {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set HorizontalSeparationColumnSeparator after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{HorizontalSeparationColumnSeparator} = $value;
}

sub get_horizontal_separation_column_separator {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{HorizontalSeparationColumnSeparator};
}

# --- HorizontalSeparationChar ---------------------------------------------------------------

sub set_horizontal_separation_char {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set HorizontalSeparationChar after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{HorizontalSeparationChar} = $value;
}

sub get_horizontal_separation_char {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{HorizontalSeparationChar};
}

# --- HorizontalSeparationBoldChar ---------------------------------------------------------------

sub set_horizontal_separation_bold_char {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set HorizontalSeparationBoldChar after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{HorizontalSeparationBoldChar} = $value;
}

sub get_horizontal_separation_bold_char {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{HorizontalSeparationBoldChar};
}

# --- ConfigureColumnAction ---------------------------------------------------------------

sub set_configure_column_action {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set ConfigureColumnAction after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{ConfigureColumnAction} = $value;
}

sub get_configure_column_action {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{ConfigureColumnAction};
}

# --- ConfigureCompleteAction ---------------------------------------------------------------

sub set_configure_complete_action {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set ConfigureCompleteAction after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{ConfigureCompleteAction} = $value;
}

sub get_configure_complete_action {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{ConfigureCompleteAction};
}

# --- default_cell_value ---------------------------------------------------------------

sub set_default_cell_value {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set default_cell_value after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{default_cell_value} = $value;
}

sub get_default_cell_value {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{default_cell_value};
}

# --- CellOutputAction ---------------------------------------------------------------

sub set_cell_output_action {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set CellOutputAction after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{CellOutputAction} = $value;
}

sub get_cell_output_action {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{CellOutputAction};
}

# --- HeaderOutputAction ---------------------------------------------------------------

sub set_header_output_action {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set HeaderOutputAction after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{HeaderOutputAction} = $value;
}

sub get_header_output_action {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{HeaderOutputAction};
}

# --- RowOutputAction ---------------------------------------------------------------

sub set_row_output_action {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set RowOutputAction after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{RowOutputAction} = $value;
}

sub get_row_output_action {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{RowOutputAction};
}

# --- StartTableOutputAction ---------------------------------------------------------------

sub set_start_table_output_action {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set StartTableOutputAction after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{StartTableOutputAction} = $value;
}

sub get_start_table_output_action {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{StartTableOutputAction};
}

# --- EndTableOutputAction ---------------------------------------------------------------

sub set_end_table_output_action {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set EndTableOutputAction after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{EndTableOutputAction} = $value;
}

sub get_end_table_output_action {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{EndTableOutputAction};
}

# --- RowGroupChangesAction --------------------------------------------------

sub set_row_group_changes_action {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    if ($self->configure_is_complete()) {
        warn ("Cannot set RowGroupChangesAction after configuration has been completed in ".(caller(3))[3]."\n");
        return;
    }
    
    $self->{RowGroupChangesAction} = $value;
}

sub get_row_group_changes_action {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{RowGroupChangesAction};
}

# --- verbose ---------------------------------------------------------------

sub set_verbose {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;
    
    $self->{verbose} = $value;
}

sub get_verbose {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{verbose};
}

#--------------------------------------------------------------------------------
#
#  Methods
#
#--------------------------------------------------------------------------------

# --- CellOutputActions ---------------------------------------------------------------

sub add_cell_output_action {
    my ($self,        # instance_ref
        $value        # value to set
        ) = @_;

    my $cell_output_actions_ref = $self->{CellOutputActions};

    print "### add_cell_output_action: $value\n" if verbose($self, 3);
    
    push (@$cell_output_actions_ref, $value);
}

sub get_cell_output_actions {
    my ($self,        # instance_ref
        ) = @_;
    
    return $self->{CellOutputActions};
}

# --- store name and action for column ------------------------------------------
sub cc {
    my $self = shift; # instance_ref
    $self->configure_column(@_);
}

# --- store name and action for column ------------------------------------------
sub conf_col {
    my $self = shift; # instance_ref
    $self->configure_column(@_);
}

# --- store name and action for column ------------------------------------------
sub configure_column {
    my $self = $_[0]; # instance_ref
    
    my $action = $self->get_configure_column_action();

    die "no action to store export column defined!" unless ref ($action);
    
    $action->(@_);
}

# --- create action and trace --------------------------------------------------
sub create_action {
    my ($self,        # instance_ref
        $action_str   # will be evaled to a sub { ... }
        ) = @_;

    my $eval_str = 'sub { '.$action_str.' }';

    print "### eval_str = $eval_str\n" if verbose($self, 3);

    my $sub_ref = eval ($eval_str);

    if (!$sub_ref || $@) {
        die "cannot create action with: $action_str\n"
            ."               eval error: $@";
    } 

    print "### ref(sub_ref) ".ref($sub_ref) ."\n" if verbose($self, 3);
    return $sub_ref;
}

# --- Now all columns are defined ---------------------------
sub configure_complete {
    my $self = $_[0]; # instance_ref
    
    my $action = $self->get_configure_complete_action();

    die "no action to complete configuration defined!" unless ref ($action);
    
    $action->(@_);

    $self->{configure_complete} = 1;

    if (verbose($self, 4)) {
        my $cell_output_actions = $self->get_cell_output_actions();
        print "### cell_output_actions: $cell_output_actions\n";
        print "###             count  : ".scalar (@$cell_output_actions)."\n";

        foreach my $action (@$cell_output_actions) {
            print "###   action: " . $action. "\n";
        }
    }
}

# --- Now all columns are defined ---------------------------
sub configure_is_complete {
    my $self = $_[0]; # instance_ref

    return $self->{configure_complete};
}

# --- get table header row output ---------------------
sub get_header_output {
    my ($self,          # instance_ref
        $headers_ref,   # optional: ref to array with header texts
        ) = @_;

    my $action = $self->get_header_output_action();
    die "No action to output header defined!" unless $action;

    $headers_ref = $self->get_header_texts_ref() unless $headers_ref;
    
    $action->($self, $headers_ref);
}

# --- get output of given row ---------------------
sub get_row_output {
    my ($self,      # instance_ref
        $data_ref   # data to give out
        ) = @_;

    my $action = $self->get_row_output_action();
    die "No action to output row defined!" unless $action;

    $action->($self, $data_ref);
}

# --- get output of (table) start ---------------------
sub get_output_start {
    my ($self,      # instance_ref
        $data_ref   # data to give out
        ) = @_;

    my $action = $self->get_start_table_output_action();
    die "No action to start table defined!" unless $action;

    $action->($self, $data_ref);
}

# --- get output of (table) end ---------------------
sub get_output_end {
    my ($self,      # instance_ref
        $data_ref   # data to give out
        ) = @_;

    my $action = $self->get_end_table_output_action();
    die "No action to end table defined!" unless $action;

    $action->($self, $data_ref);
}

# --- Interprete File Parameter and return open file handle ---
sub interprete_file_parameter {
    my ($self,           # instance_ref
        $file_parameter  # FileHandle or file name for output
        ) = @_;

    my $file_handle;

    if ($file_parameter) {
        my $file_ref = ref($file_parameter);

        if ($file_ref) {
            unless ($file_ref =~ /^FileHandle$/) {
                croak 'Only FileHandle or $file_name_string allowed as file parameter!';
            }
            $file_handle = $file_parameter;
        }
        else {
            $file_handle = FileHandle->new($file_parameter, 'w');
            croak "can't open file '$file_parameter' to write: $!\n" unless $file_handle;
        }
    }
    else {
        $file_handle = *STDOUT;
    }

    return $file_handle;
}

sub write_table {
    my ($self,           # instance_ref
        $data_rows_ref,  # list of data_rows to give out
        $file_handle,    # FileHandle for output
        ) = @_;
        
    my $row_output_action = $self->get_row_output_action();

    foreach my $data (@{$data_rows_ref}) {
        print $file_handle $row_output_action->($self, $data);
    }

}

# --- Write out everything in one step ----
sub write_all {
    my ($self,           # instance_ref
        $data_rows_ref,  # list of data_rows to give out
        $file_parameter  # Optional: FileHandle or file name for output
        ) = @_;

    my $file_handle = $self->interprete_file_parameter($file_parameter);

    print $file_handle $self->get_output_start();

    $self->write_table($data_rows_ref, $file_handle);
        
    print $file_handle $self->get_output_end();
}

1;

=head1 NAME

C<Report::Porf::Table::Simple>

Reports for any output format as simple table:
One line in output per data row.

Part of Perl Open Report Framework (Porf).

=head1 Documentation

Use C<Configurator> or C<Framework> of namespace C<Report::Porf::*> to
create Instances, that export data as text, html, csv, LaTeX, for
wikis or Excel.

See Framework.pm for documentation of features and usage.

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2013 by Ralf Peine, Germany.  All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.6.0 or,
at your option, any later version of Perl 5 you may have available.

=head1 DISCLAIMER OF WARRANTY

This library is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

=cut
