package org.xcede.XCEDE2WS;

import java.lang.reflect.*;
import java.lang.String;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.net.URL;
import java.net.URLStreamHandler;
import java.net.URLConnection;

public class Functions {
    public Functions() {
    }
    
    
}

sub parse_params {
  my $inputhashref = shift;
  my @paramkeys = @_;

  my %inputhash = %$inputhashref;
  my @retlist = ();
  for my $paramkey (@paramkeys) {
    if (exists($inputhash{$paramkey})) {
      push @retlist, $inputhash{$paramkey};
      delete $inputhash{$paramkey};
    } else {
      push @retlist, undef;
    }
  }
  return @retlist, %inputhash;
}

# main switchyard
sub execute {
  my $this = shift;
  my $funcname = shift;
  my $paramhashref = shift;
  my $funchash = $this->{'funchash'};
  if (!exists($funchash->{$funcname})) {
    return HTTP::Response->new(RC_BAD_REQUEST, "Function '$funcname' not recognized\n");
  }
  my ($func, undef) = @{$funchash->{$funcname}};
  my ($retcode, @retlist) = $func->($this, $paramhashref);
  my $retxml = "<?xml version=\"1.0\"?>\n<list>\n";
  while (scalar(@retlist) > 0) {
    my $itemid = shift @retlist;
    my $itemcontent = shift @retlist;
    $retxml .= " <item id=\"$itemid\">";
    if (ref($itemcontent) eq 'ARRAY') {
      my @fields = @$itemcontent;
      $retxml .= "\n";
      while (scalar(@fields)) {
	my $fieldid = shift @fields;
	my $fieldcontent = shift @fields;
	$retxml .= "  <field id=\"$fieldid\">$fieldcontent</field>\n";
      }
    } else {
      $retxml .= "$itemcontent"
    }
    $retxml .= " </item>\n";
  }
  $retxml .= "</list>\n";
  my $headers = HTTP::Headers->new;
  $headers->header('Content-Type' => 'text/xml');
  return HTTP::Response->new($retcode, 'OK', $headers, $retxml);
}

# web service functions
sub func_get_function_list {
  my $this = shift;
  my $inputhashref = shift;
  my @retval = ();
  my (%uncommitted) = parse_params($inputhashref);
  if (scalar(%uncommitted) > 0) {
    push @retval, 'message', 'Unrecognized parameters: "' . join('"', keys %uncommitted) . '"';
    return RC_BAD_REQUEST, @retval;
  }
  for my $funcname (keys %{$this->{'funchash'}}) {
    my ($func, $funcdoc) = @{$this->{'funchash'}->{$funcname}};
    push @retval, 'function', ['name', $funcname, 'documentation', $funcdoc];
  }
  push @retval, 'message', 'No errors.';
  return RC_OK, @retval;
}

END { }		       # module clean-up code here (global destructor)

1;		   # don’t forget to return a true value from the file
