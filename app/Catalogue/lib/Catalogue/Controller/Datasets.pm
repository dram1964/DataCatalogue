package Catalogue::Controller::Datasets;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

Catalogue::Controller::Datasets - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body(
        'Matched Catalogue::Controller::Datasets in Datasets.');
}

=head2 base

Can place common logic to start a chained dispatch here

=cut 

sub base : Chained('/') : PathPart('datasets') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::Dataset') );
    $c->load_status_msgs;
}

=head2 object

Fetch the specified dataset object based on the class id and store it in the stash

=cut 

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $c->stash( object => $c->stash->{resultset}->find($id) );

    die "Class not found" if !$c->stash->{object};

}

=head2 search

Search for datasets

=cut

sub search : Chained('base') : PathPart('search') : Args(0) {
    my ( $self, $c ) = @_;
    my $search_term = "%" . $c->request->params->{search} . "%";
    my $dataset_rs  = $c->stash->{resultset}->search(
        {   -or => [
                { 'name'        => { like => $search_term } },
                { 'description' => { like => $search_term } },
            ]
        }
    );
    my $datasets = [ $dataset_rs->all ];
    $c->stash(
        datasets => $datasets,
        template => 'datasets/list.tt2'
    );
}

=head2 list 

List all Datasets 

=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;
    my $datasets = [ $c->stash->{resultset}->all ];
    $c->stash(
        datasets => $datasets,
        template => 'datasets/list.tt2'
    );
}

=head2 add

Add new Dataset

=cut

sub add : Chained('base') : PathPart('add') : Args(0) : FormConfig {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless defined( $c->user )
        && $c->stash->{resultset}
        ->first->edit_allowed_by( $c->user->get_object );

    my $form = $c->stash->{form};
    if ( $form->submitted_and_valid ) {
        my $dataset_name        = $c->request->params->{name};
        my $dataset_description = $c->request->params->{description};
        my $dataset             = $c->model('DB::Dataset')->new_result(
            {   name        => $dataset_name,
                description => $dataset_description,
            }
        );
        $form->model->update($dataset);
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_status_msg("Dataset Added") }
            )
        );
        $c->detach;
    }
    $c->stash( template => 'datasets/add.tt2' );
}

=head2 edit

Edit a dataset

=cut

sub edit : Chained('object') : PathPart('edit') : Args(0)
    : FormConfig('datasets/add.yml') {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless defined( $c->user )
        && $c->stash->{object}->edit_allowed_by( $c->user->get_object );

    my $dataset = $c->stash->{object};
    unless ($dataset) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                {   mid => $c->set_error_msg("Invalid dataset -- Cannot edit")
                }
            )
        );
        $c->detach;
    }
    my $form = $c->stash->{form};
    if ( $form->submitted_and_valid ) {
        $form->model->update($dataset);
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_status_msg("Dataset updated") }
            )
        );
        $c->detach;
    }
    else {
        my $name = $form->get_element( { name => 'name' } );
        $name->value( $dataset->name );
        my $description = $form->get_element( { name => 'description' } );
        $description->value( $dataset->description );
        $c->stash( dataset => $dataset );
    }
    $c->stash( template => 'datasets/add.tt2' );
}

=head2 explore

Explore the selected dataset

=cut

sub explore : Chained('object') : PathPart('explore') : Args(0) {
    my ( $self, $c ) = @_;
    my $dataset  = $c->stash->{object};
    my $datasets = [ $c->stash->{resultset}->all ];
    $c->stash(
        datasets => $datasets,
        dataset  => $dataset,
        template => 'datasets/explore.tt2'
    );
}

=head2 explore_json

Explore the selected dataset

=cut

sub explore_json : Chained('object') : PathPart('explore_json') : Args(0) {
    my ( $self, $c ) = @_;
    my $dataset  = $c->stash->{object};
    my $datasets = [ $c->stash->{resultset}->all ];
    my $facts    = [ $c->stash->{object}->dataset_facts->all ];
    $c->stash(
        datasets => $datasets,
        dataset  => $dataset,
        facts    => $facts,
        template => 'datasets/explore_json.tt2'
    );
}

=head2 delete

Delete the Dataset

=cut

sub delete : Chained('object') : PathPart('delete') : Args(0) {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{object}->delete_allowed_by( $c->user->get_object );
    $c->stash->{object}->delete;
    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            { mid => $c->set_status_msg("Dataset Deleted.") }
        )
    );
}

=head2 explore_ng

explore datasets with angularJS

=cut

sub explore_ng : Chained('object') : PathPart('explore_ng') : Args(0) {
    my ( $self, $c ) = @_;
    my $dataset  = $c->stash->{object};
    my $datasets = [ $c->stash->{resultset}->all ];
    my $facts    = [ $c->stash->{object}->dataset_facts->all ];
    $c->stash(
        datasets => $datasets,
        dataset  => $dataset,
        facts    => $facts,
        template => 'datasets/explore_ng.tt2'
    );
}

=encoding utf8

=head1 AUTHOR

David Ramlakhan

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
