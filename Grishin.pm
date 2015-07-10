package XML::Grishin;
require Exporter;

use warnings;
use strict;

use XML::LibXML;

our @ISA    = qw(Exporter);
our @EXPORT = (
    "&xml_write",
    "&xml_open",
    "&xml_create",
    "&create_job",
    "&create_job_dir_nodes_for_job_xml",
    "&find_nodes",
    "&find_job_nodes",
    "&find_family_nodes",
    "&find_first_node",
    "&find_uids",
    "&find_manual_domain_nodes",
	"&find_provisional_domain_nodes",
	"&find_chain_nodes",
	"&is_manual_domain_rep",
    "&find_domain_nodes",
    "&find_domain_parse_nodes",
    "&find_domain_node",
	"&find_domain_reps",
    "&find_pf_group_nodes",
    "&find_sequence_nodes",
    "&find_dali_hit_nodes",
    "&find_run_list_nodes",
	"&find_uniprot_nodes",
	"&get_structure_node",
    "&get_ecodf_acc",
    "&get_short_ecodf_acc",
    "&get_ecodf_family_dir",
    "&get_ids",
    "&get_pf_id",
	"&get_chain_id",
	"&get_pdb_id",
	"&get_ecodf_acc",
    "&get_pf_id_from_domain_node",
	"&get_cluster_id",
    "&get_dali_scores",
    "&get_dali_fn",
    "&get_dali_regions",
    "&get_ecodf_id",
    "&get_reference",
    "&get_seqid_range",
    "&get_seqid_range_node",
	"&get_text",
    "&get_job_dirs_from_job_xml",
    "&get_pdb_range",
    "&get_pdb_range_node",
    "&get_pdb_chain",
    "&get_pdb_chain_from_job_node",
    "&get_pdb_chain_from_domain_node",
    "&get_pdb_chain_from_pdb_chain_node",
    "&get_run_list_job_xml_file",
    "&get_h_id_from_domain_node",
	"&get_unp_range",
    "&get_week_label",
    "&hasReps_job_list",
    "&isCoiledCoil",
    "&isPeptide",
    "&isObsolete",
	"&isRep95",
    "&isClusterRep",
    "&job_node_pdb_chain",
    "&dump_node_report",
);

sub create_job {
    my ( $xml_doc, $href ) = @_;

    my $job_node = $xml_doc->createElement('job');
    $job_node->setAttribute( 'id', $$href{id} );

    $job_node->setAttribute( 'id', $$href{id} );

    $job_node->appendTextChild( 'query_pdb',   $$href{query_pdb} );
    $job_node->appendTextChild( 'query_chain', $$href{query_chain} );
    $job_node->appendTextChild( 'reference',   $$href{reference} );
    $job_node->appendTextChild( 'mode',        $$href{mode} );

    return $job_node;

}

sub get_run_list_job_xml_file {
    return $_[0]->findvalue(qq{run_list_job_xml_file[\@mode="$_[1]"]});
}


sub create_job_dir_nodes_for_job_xml {
    my ( $xml_doc, $root_node, $job_list_dir ) = @_;

    my $job_dir_node = $xml_doc->createElement('job_list_dir');
    $job_dir_node->appendTextNode($job_list_dir);
    $root_node->appendChild($job_dir_node);

    my $dump_dir_node = $xml_doc->createElement('job_dump_dir');
    $dump_dir_node->appendTextNode("$job_list_dir/ecod_dump");
    $root_node->appendChild($dump_dir_node);

    my $job_list_node = $xml_doc->createElement('job_list');
    $root_node->appendChild($job_list_node);

}


sub get_structure_node { 
	$_[0]->findnodes('./structure')->get_node(1);
}

sub get_pf_id {
    if ( $_[0]->nodeName eq 'domain' ) {
        return get_pf_id_from_domain_node( $_[0] );
    }
    elsif ( $_[0]->nodeName eq 'pf_group' ) {
        return get_pf_id_from_pf_group( $_[0] );
    }
    else {
        return 0;
    }
}

sub get_weekly_update_dir {
    return $_[0]->findvalue('//weekly_update_dir');
}

sub get_week_label {
    return $_[0]->findvalue('@week_label');
}

sub hasDomains {
    return $_[0]->exists('.//domain') ? 1 : 0;
}

sub hasReps_job_list {
    return $_[0]->exists('//job/@rep95') ? 1 : 0;
}

sub isClusterRep {
    $_[0]->findvalue(qq{cluster[\@level="$_[1]"]/\@domain_rep}) eq 'true';
}
sub get_cluster_id { 
	$_[0]->findvalue(qq{cluster[\@level="$_[1]"]/\@id});
}

sub isPeptide {
    if ( $_[0]->nodeName eq 'pdb_chain' ) {
        if ( $_[0]->findvalue('@peptide_filter') eq 'true' ) {
            return 1;
        }
    }elsif($_[0]->nodeName eq 'job') { 
		if ($_[0]->findvalue('peptide_filter/@apply') eq 'true') { 
			return 1;
		}
	}
    return 0;
}

sub isCoiledCoil {
    if ( $_[0]->nodeName eq 'pdb_chain' ) {
        if ( $_[0]->findvalue('coiled_coil_filter/@apply') eq 'true' ) {
            return 1;
        }
    }
    return 0;
}

sub isRep95 { 
	$_[0]->findvalue('@rep95');
}

sub isObsolete {
    if ( $_[0]->nodeName eq 'domain' ) {
        if ( $_[0]->findvalue('structure/@structure_obsolete') eq 'true' ) {
            return 1;
        }
    }
    return 0;
}

sub dump_node_report {
    my ( $nodeList, $querysub ) = @_;
    foreach my $node ( $nodeList->get_nodelist() ) {
        print &$querysub($node) . "\n";
    }
}

#find_ = Returns XML::NodeList;
sub find_chain_nodes  { 
	$_[0]->findnodes('.//chain');
}

sub find_domain_reps {
    my @n = map {$_->parentNode} $_[0]->findnodes(qq{.//domain/cluster[\@level='$_[1]'][\@domain_rep="true"]});
	return XML::LibXML::NodeList->new(@n)->get_nodelist();
}

sub find_dali_hit_nodes {
    return $_[0]->findnodes('//dali_hits/hit');
}

sub find_run_list_nodes {
    my $path = '//run_list_summary_doc/run_list_summary/run_list';
    $_[0]->exists($path) ? $_[0]->findnodes($path) : 0;
}

sub find_domain_parse_nodes {
    $_[0]->findnodes('//domain_parse_run');
}

sub find_nodes {
    $_[0]->findnodes( $_[1] );
}

sub find_first_node {
    $_[0]->findnodes( $_[1] )->get_node(1);
}

sub find_job_nodes {
    $_[0]->findnodes('//job');
}

sub find_pf_group_nodes {
    $_[0]->findnodes('.//pf_group');
}

sub find_family_nodes {
    $_[0]->findnodes('.//family');
}

sub find_domain_nodes {
    $_[0]->findnodes('.//domain');
}

sub find_domain_node {
    $_[0]->findnodes(qq{.//domain[\@uid="$_[1]"]})->get_node(1);
}

sub find_manual_domain_nodes {
    $_[0]->findnodes('.//domain[@manual_rep="true"]');
}

sub find_provisional_domain_nodes { 
	$_[0]->findnodes('.//domain[@provisional_manual_rep="true"]');
}

sub is_manual_domain_rep { 
	$_[0]->findvalue('@manual_rep') eq 'true';
}

sub find_sequence_nodes {
    $_[0]->findnodes('.//sequence');
}

#get_ = Returns XML::Node or value
sub get_chain_id { 
	$_[0]->findvalue('@chain_id');
}
sub get_pdb_id { 
	$_[0]->findvalue('@pdb_id');

}
sub get_ecodf_id {
    $_[0]->findvalue('@ecodf_id');
}

sub get_job_dirs_from_job_xml {
    $_[0]->findvalue('//job_set_top/job_dump_dir'), $_[0]->findvalue('//job_set_top/job_list_dir');
}

sub get_dali_scores {
    $_[0]->findvalue('@z-score'), $_[0]->findvalue('@RMSD'), $_[0]->findvalue('@identity');
}

sub get_dali_fn {
    $_[0]->findvalue('dali_file');
}

sub get_dali_regions {
    $_[0]->findvalue('hit_reg'), $_[0]->findvalue('query_reg'), $_[0]->findvalue('@coverage');

}

sub get_pf_id_from_pf_group {
     $_[0]->findvalue('@pf_id');
}

sub get_pdb_chain {
    if ( $_[0]->nodeName eq 'domain' ) {
        return get_pdb_chain_from_domain_node( $_[0] );
    }
    elsif ( $_[0]->nodeName eq 'job' ) {
        return get_pdb_chain_from_job_node( $_[0] );
    }
    elsif ( $_[0]->nodeName eq 'pdb_chain' ) {
        return get_pdb_chain_from_pdb_chain_node( $_[0] );
    }
    else {
        warn "WARNING! Unrecognized node: " . $_[0]->nodeName . ", skipping...	\n";
    }
}

sub get_pdb_chain_from_domain_node {
    ( $_[0]->findvalue('structure/@pdb_id'), $_[0]->findvalue('structure/@chain_id') );
}

sub get_pdb_chain_from_job_node {
    my $pdb   = $_[0]->findvalue('query_pdb');
    my $chain = $_[0]->findvalue('query_chain');
    return ( $pdb, $chain );
}

sub get_pdb_chain_from_pdb_chain_node {
    my $pdb   = $_[0]->findvalue('@pdb');
    my $chain = $_[0]->findvalue('@chain');
    return ( $pdb, $chain );
}

sub get_seqid_range_node {
    $_[0]->exists('seqid_range')
      ? $_[0]->findnodes('seqid_range')->get_node(1)
      : $_[0]->findnodes('derived_seqid_range')->get_node(1);
}

sub get_pdb_range_node {
    $_[0]->exists('range')
      ? $_[0]->findnodes('range')->get_node(1)
      : $_[0]->findnodes('derived_range')->get_node(1);

}

sub get_seqid_range {
    $_[0]->exists('seqid_range') ? $_[0]->findvalue('seqid_range') : $_[0]->findvalue('derived_seqid_range');
}

sub get_pdb_range {
    $_[0]->exists('range') ? $_[0]->findvalue('range') : $_[0]->findvalue('derived_range');
}

sub get_pf_id_from_domain_node {
    $_[0]->parentNode->nodeName eq 'pf_group'
      ? $_[0]->parentNode->findvalue('@pf_id')
      : $_[0]->parentNode->parentNode->findvalue('@pf_id');
}

sub get_h_id_from_domain_node {
	$_[0]->parentNode or return 0;
	$_[0]->exists('@h_id') ? $_[0]->findvalue('@h_id') : get_h_id_from_domain_node($_[0]);
}

sub get_ids {
    ( $_[0]->findvalue('@uid'), $_[0]->findvalue('@ecod_domain_id') );
}

sub find_uids {
    map { $_->exists('@uid') ? $_->findvalue('@uid') : "NaN" } $_[0]->get_nodelist();
}

sub get_reference {
    $_[0]->findvalue('reference');
}

sub get_ecodf_family_dir {
    my $ecodf_acc = get_ecodf_acc( $_[0] );
    $ecodf_acc =~ /EF(\d{2})/;
    "$_[1]/$1/$ecodf_acc/";
}

sub get_ecodf_acc {
    $_[0]->findvalue('@ecodf_acc');
}

sub get_short_ecodf_acc {
    $_[0]->findvalue('@ecodf_acc') =~ /(EF\d+)\./;
    return $1;
}

sub get_uid {
    $_[0]->findvalue('@uid');
}

sub job_node_pdb_chain {
    my $pdb   = $_[0]->findvalue('query_pdb');
    my $chain = $_[0]->findvalue('query_chain');
    return wantarray ? ( $pdb, $chain ) : $pdb . "_" . $chain;
}

sub node_uid {
    sprintf "%09i\n", $_[0]->findvalue('@uid');
}

sub strip_nodes {
    my ( $node, $searchsub ) = @_;
    map { $_->unbindNode } &$searchsub($node);
}

sub get_text { 
	$_[0]->findvalue('text()');
}
sub find_uniprot_nodes { 
	$_[0]->findnodes('uniprot');
}
sub get_unp_range { 
	$_[0]->findvalue('unp_range');
}
sub get_unp_acc { 
	$_[0]->findvalue('@unp_acc');
}
#XML shortcut funcs
sub xml_create {
    my $root      = $_[0];
    my $xml_doc   = XML::LibXML->createDocument();
    my $root_node = $xml_doc->createElement($root);
    $xml_doc->setDocumentElement($root_node);
    return ( $xml_doc, $root_node );
}

sub xml_write {
    open my $xml_fh, ">", $_[1] or die "ERROR! Could not open $_[1] for writing:$!\n";
    $_[0]->toFH( $xml_fh, 1 );
}

sub xml_open {
    open my $xml_fh, "<", $_[0] or die "ERROR! COuld not open $_[0] for reading\n";
    my $xml_doc = XML::LibXML->load_xml( IO => $xml_fh );
    return $xml_doc;
}



