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
	"&find_architecture_nodes",
    "&find_job_nodes",
	"&find_job_asm_nodes",
    "&find_family_nodes",
    "&find_first_node",
    "&find_uids",
    "&find_manual_domain_nodes",
	"&find_provisional_domain_nodes",
	"&find_chain_nodes",
	"&is_manual_domain_rep",
	"&is_provisional_domain_rep",
    "&find_domain_nodes",
	"&find_domain_assembly_nodes",
	"&find_strict_domain_nodes",
    "&find_domain_parse_nodes",
    "&find_domain_node",
	"&find_strict_domain_reps",
	"&find_run_list_summary_nodes",
	"&find_domain_reps",
	"&find_pdb_nodes",
    "&find_pf_group_nodes",
	"&find_h_group_nodes",
	"&find_f_group_nodes",
	"&find_x_group_nodes",
    "&find_sequence_nodes",
    "&find_dali_hit_nodes",
	"&find_hhsearch_hit_nodes",
    "&find_run_list_nodes",
	"&find_uniprot_nodes",
	"&get_name",
	"&get_arch_ordinal",
	"&get_arch_comment",
	"&get_structure_node",
    "&get_ecodf_acc",
    "&get_short_ecodf_acc",
    "&get_ecodf_family_dir",
    "&get_ids",
	"&get_id",
	"&get_uid",
	"&get_ecod_domain_id",
	"&get_scop_domain_id",
	"&get_arch_id",
	"&get_arch_name",
    "&get_pf_id",
	"&get_x_id",
	"&get_x_ordinal",
	"&get_h_id",
	"&get_h_ordinal",
	"&get_f_id",
	"&get_f_ordinal",
	"&get_chain_id",
	"&get_pdb_id",
	"&get_ecodf_acc",
    "&get_pf_id_from_domain_node",
	"&get_f_id_from_domain_node",
	"&get_f_node_from_domain_node",
	"&get_cluster_id",
    "&get_dali_scores",
    "&get_dali_fn",
    "&get_dali_regions",
    "&get_ecodf_id",
	"&get_job_id",
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
	"&get_version",
	"&has_arch_name",
	"&has_arch_id",
	"&has_x_ordinal",
	"&has_x_id",
	"&has_h_ordinal",
	"&has_h_id",
	"&has_f_ordinal",
	"&has_f_id",
	"&has_name",
	"&has_arch_comment",
	"&has_arch_ordinal",
	"&has_ligand_annotation",
	"&has_previous_ecod_fn",
	"&has_premerge_ecod_fn",
	"&has_manual_table_fn",
	"&has_merge_fn",
	"&has_previous_ecod_fn",
	"&has_chainwise_ecod_fn",
	"&has_ecod_tmp_fn",
	"&has_ecod_fn",
	"&has_derived_libraries",
	"&has_update_hmmer_db",
	"&has_ecod_rep_domain_node",
	"&get_previous_ecod_fn",
	"&get_premerge_ecod_fn",
	"&get_merge_fn",
	"&get_manual_table_fn",
	"&get_chainwise_ecod_fn",
	"&get_ecod_tmp_fn",
	"&get_ecod_fn",
	"&get_derived_libraries",
	"&get_update_hmmer_db",
	"&get_ecod_xml_node",
	"&get_derived_libraries_node",
	"&overlaps_cleaned",
	"&ligands_annotated",
	"&pfam_clustered",
	"&version_registered",
	"&divergence_calculated",
	"&divergence_repaired",
	"&representatives_calculated",
	"&statistics_updated",
    "&hasReps_job_list",
    "&isCoiledCoil",
    "&isPeptide",
    "&is_obsolete",
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

sub get_x_id { 
	$_[0]->findvalue('@x_id');
}
sub get_f_id { 
	$_[0]->findvalue('@f_id');
}
sub get_h_id { 
	$_[0]->findvalue('@h_id');
}

sub get_x_ordinal { 
	$_[0]->findvalue('@x_ordinal');
}
sub get_h_ordinal { 
	$_[0]->findvalue('@h_ordinal');
}
sub get_f_ordinal { 
	$_[0]->findvalue('@f_ordinal');
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
sub get_arch_id { 
	$_[0]->findvalue('@arch_id');
}

sub get_arch_name { 
	$_[0]->findvalue('@arch_name');
}

sub get_arch_comment { 
	$_[0]->findvalue('arch_comment');
}

sub get_arch_ordinal { 
	$_[0]->findvalue('@arch_ordinal');
}

sub get_weekly_update_dir {
    return $_[0]->findvalue('//weekly_update_dir');
}

sub get_week_label {
    return $_[0]->findvalue('@week_label');
}

sub has_ligand_annotation { 
	$_[0]->exists('ligand_str');
}

sub has_arch_comment { 
	$_[0]->exists('arch_comment');
}
sub has_arch_ordinal { 
	$_[0]->exists('@arch_ordinal');
}
sub has_x_ordinal {
	$_[0]->exists('@x_ordinal');
}
sub has_h_ordinal { 
	$_[0]->exists('@h_ordinal');
}
sub has_f_ordinal { 
	$_[0]->exists('@f_ordinal');
}
sub has_arch_name { 
	$_[0]->exists('@arch_name');
}
sub has_arch_id { 
	$_[0]->exists('@arch_id');
}

sub has_name { 
	$_[0]->exists('@name');
}




sub hasDomains {
    return $_[0]->exists('.//domain') ? 1 : 0;
}

sub hasReps_job_list {
    return $_[0]->exists('//job/@rep95') ? 1 : 0;
}

sub isClusterRep {
	warn "WARNING! isClusterRep is defunct!\n";
    $_[0]->findvalue(qq{cluster[\@level="$_[1]"]/\@domain_rep}) eq 'true';
}

sub get_name { 
	$_[0]->findvalue('@name');
}
sub get_cluster_id { 
	$_[0]->findvalue(qq{cluster[\@level="$_[1]"][\@method="$_[2]"]/\@id});
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

sub is_obsolete {
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

sub find_architecture_nodes { 
	$_[0]->findnodes('//architecture');	
}

sub find_chain_nodes  { 
	$_[0]->findnodes('.//chain');
}

sub find_domain_assembly_nodes { 
	$_[0]->findnodes('domain_assembly');
}

sub find_domain_reps {
    my @n = map {$_->parentNode} $_[0]->findnodes(qq{.//domain/cluster[\@level='$_[1]'][\@domain_rep="true"][\@method="$_[2]"]});
	
	return XML::LibXML::NodeList->new(@n)->get_nodelist();
}

sub find_strict_domain_reps { 
    my @n = map {$_->parentNode} $_[0]->findnodes(qq{./domain/cluster[\@level='$_[1]'][\@domain_rep="true"][\@method="$_[2]"]});
	
	return XML::LibXML::NodeList->new(@n)->get_nodelist();

}

sub find_dali_hit_nodes {
    return $_[0]->findnodes('//dali_hits/hit');
}

sub find_hhsearch_hit_nodes { 
	return $_[0]->findnodes('//hh_run/hits/hit');
}

sub find_run_list_nodes {
    my $path = '//run_list';
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
sub find_job_asm_nodes {
	$_[0]->findnodes('//job_asm');
}

sub find_pdb_nodes { 
	$_[0]->findnodes('.//pdb');
}

sub find_pf_group_nodes {
    $_[0]->findnodes('.//pf_group');
}

sub find_h_group_nodes { 
	$_[0]->findnodes('.//h_group');	
}

sub find_f_group_nodes { 
	$_[0]->findnodes('.//f_group');
}
sub find_x_group_nodes { 
	$_[0]->findnodes('.//x_group');
}

sub find_family_nodes {
    $_[0]->findnodes('.//family');
}

sub find_domain_nodes {
    $_[0]->findnodes('.//domain');
}

sub find_strict_domain_nodes { 
	$_[0]->findnodes('./domain');
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
	$_[0]->findvalue('@manual_rep') eq 'true' ? 1 : 0;
}

sub is_provisional_domain_rep { 
	$_[0]->findvalue('@provisional_manual_rep') eq 'true' ? 1 : 0;
}

sub find_sequence_nodes {
    $_[0]->findnodes('.//sequence');
}

#get_ = Returns XML::Node or value
sub get_chain_id { 
	#$_[0]->findvalue('@chain_id');
	$_[0]->getAttribute('chain_id');
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
	elsif ( $_[0]->nodeName eq 'job_asm') { 
		return get_pdb_chain_from_job_asm_node( $_[0] );
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

sub get_pdb_chain_from_job_asm_node { 
	my $pdb 	= $_[0]->findvalue('query_pdb');
	my $chains 	= $_[0]->findvalue('query_chains');
	my @c = split(/\,/, $chains);
	return ($pdb, \@c);
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

sub get_f_id_from_domain_node { 
	$_[0]->nodeName eq 'h_group' and return 0;
	$_[0]->nodeName eq 'f_group' ? 
		return $_[0]->findvalue('@f_id') : get_f_id_from_domain_node($_[0]->parentNode);
}

sub get_f_node_from_domain_node { 
	$_[0]->parentNode or return 0;
	$_[0]->nodeName eq 'f_group' ? $_[0] : get_f_node_from_domain_node($_[0]->parentNode);
}

sub get_h_id_from_domain_node {
	$_[0]->parentNode or return 0;
	$_[0]->exists('@h_id') ? $_[0]->findvalue('@h_id') : get_h_id_from_domain_node($_[0]->parentNode);
}
#Bad naming
sub get_ids {
    ( $_[0]->findvalue('@uid'), $_[0]->findvalue('@ecod_domain_id') );
}

sub get_id { 
	$_[0]->findvalue('@id');
}

sub get_job_id { 
	$_[0]->findvalue('@job_id');
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
sub get_ecod_domain_id { 
	$_[0]->findvalue('@ecod_domain_id');
}
sub get_scop_domain_id { 
	$_[0]->findvalue('@scop_domain_id');
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
    open my $xml_fh, "<", $_[0] or die "ERROR! Could not open $_[0] for reading\n";
    my $xml_doc = XML::LibXML->load_xml( IO => $xml_fh );
    return $xml_doc;
}

#from update_ecod.pl
#_find 
sub find_run_list_summary_nodes { 
	$_[0]->findnodes('.//run_list_summary');
}

#_has
sub has_premerge_ecod_fn { 
	$_[0]->exists('ecod_pre_xml');
}

sub has_manual_table_fn { 
	$_[0]->exists('manual_table_txt');
}

sub has_merge_fn { 
	$_[0]->exists('merge_xml');
}

sub has_previous_ecod_fn { 
	$_[0]->exists('ecod_old_xml');
}

sub has_chainwise_ecod_fn {
	$_[0]->exists('chainwise_ecod_xml');
}

sub has_ecod_tmp_fn { 
	$_[0]->exists('ecod_tmp_xml');
}

sub has_ecod_rep_domain_node { 
	$_[0]->exists('ecod_representative_domain');
}
sub has_ecod_fn { 
	$_[0]->exists('ecod_xml');
}

sub has_derived_libraries { 
	$_[0]->exists('derived_libraries');	
}
sub has_update_hmmer_db { 
	$_[0]->exists('update_hmmer_db');
}

#_get
sub get_premerge_ecod_fn { 
	$_[0]->findvalue('ecod_pre_xml');
}

sub get_previous_ecod_fn { 
	$_[0]->findvalue('ecod_old_xml');
}


sub get_manual_table_fn { 
	$_[0]->findvalue('manual_table_txt');
}
sub get_merge_fn { 
	$_[0]->findvalue('merge_xml');
}

sub get_ecod_tmp_fn { 
	$_[0]->findvalue('ecod_tmp_xml');
}

sub get_ecod_fn { 
	$_[0]->findvalue('ecod_xml');
}

sub get_chainwise_ecod_fn { 
	$_[0]->findvalue('chainwise_ecod_xml');
}

sub get_version { 
	$_[0]->findvalue('@version');
}

sub get_update_hmmer_db { 
	$_[0]->findvalue('update_hmmer_db');
}

sub get_repair_fn { 
	($_[0]->findvalue('repair_job_xml_file'), $_[0]->findvalue('repair_job_xml_file/@name'));
}

sub get_run_list_summary { 
	$_[0]->findvalue('domain_summary_file');
}


#_get_node
sub get_ecod_xml_node { 
	$_[0]->findnodes('ecod_xml')->get_node(1);
}

sub get_derived_libraries_node { 
	$_[0]->findnodes('derived_libraries')->get_node(1);
}

sub overlaps_cleaned { 
	$_[0]->findvalue('@overlaps_cleaned') eq 'true';
}
sub ligands_annotated { 
	$_[0]->findvalue('@ligands_annotated') eq 'true';
}
sub pfam_clustered { 
	$_[0]->findvalue('@pfam_clustered') eq 'true';
}
sub version_registered { 
	$_[0]->findvalue('@version_registered') eq 'true';
}
sub divergence_calculated { 
	$_[0]->findvalue('@divergence_calculated') eq 'true';
}
sub divergence_repaired { 
	$_[0]->findvalue('@divergence_repaired') eq 'true';
}
sub representatives_calculated { 
	$_[0]->findvalue('@representatives_calculated') eq 'true';
}
sub statistics_updated { 
	$_[0]->findvalue('@stats_updated') eq 'true'
}


