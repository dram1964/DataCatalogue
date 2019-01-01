package Catalogue::Controller::Tasks;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

Catalogue::Controller::Tasks - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head1 auto

Deny all access unless user has admin rights

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->user->has_role('admin');
}

=head2 index

handle unfound methods in task controller

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Catalogue::Controller::Tasks in Tasks.');
}

=head2 base

Can place common logic to start a chained dispatch here

=cut 

sub base : Chained('/') : PathPart('tasks') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::Todolist') );
    $c->load_status_msgs;
}

=head2 object

Fetch the specified task object based on the task id and store it in the stash

=cut 

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $task_id ) = @_;
    $c->stash( object => $c->stash->{resultset}->find( { id => $task_id } ) );

    die "Class not found" if !$c->stash->{object};

}

=head2 delete

Delete a task from the todolist

=cut 

sub delete : Chained('object') : PathPart('delete') : Args(0) {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{object}->delete_allowed_by( $c->user->get_object );
    $c->stash->{object}->delete;
    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            { mid => $c->set_status_msg("Task Deleted") }
        )
    );
}

=head2 list

Fetch all items in the todo list

=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{resultset}
        ->first->edit_allowed_by( $c->user->get_object );
    $c->stash(
        {   tasks    => [ $c->stash->{resultset}->all ],
            template => 'tasks/list.tt2',
        }
    );
}

=head2 create

Use HTML::FormFu to create a new task

=cut

sub create : Chained('base') : PathPart('create') : Args(0) : FormConfig {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{resultset}
        ->first->edit_allowed_by( $c->user->get_object );
    my $form = $c->stash->{form};

    if ( $form->submitted_and_valid ) {
        my $task = $c->model('DB::Todolist')->new_result( {} );
        $form->model->update($task);
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_status_msg("Task Added") }
            )
        );
        $c->detach;
    }
    else {
        my @user_objs = $c->model('DB::User')->all();
        my @users;
        foreach ( sort { $a->last_name cmp $b->last_name } @user_objs ) {
            push( @users, [ $_->username, $_->username ] );
        }
        my $select = $form->get_element( { type => 'Select' } );
        $select->options( \@users );
    }
    $c->stash( template => 'tasks/create.tt2' );
}

=head2 edit

Use HTML::FormFu to update an existing task

=cut

sub edit : Chained('object') : PathPart('edit') : Args(0)
    : FormConfig('tasks/create.yml') {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{object}->edit_allowed_by( $c->user->get_object );
    my $task = $c->stash->{object};
    unless ($task) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_error_msg("Invalid task -- Cannot edit") }
            )
        );
        $c->detach;
    }

    my $form = $c->stash->{form};
    if ( $form->submitted_and_valid ) {
        $form->model->update($task);
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_status_msg("Task updated") }
            )
        );
        $c->detach;
    }
    else {
        my @user_objs = $c->model('DB::User')->all();
        my @users;
        foreach ( sort { $a->last_name cmp $b->last_name } @user_objs ) {
            push( @users, [ $_->username, $_->username ] );
        }
        my $select = $form->get_element( { type => 'Select' } );
        $select->options( \@users );
        my $task_name = $form->get_element( { name => 'task' } );
        $task_name->value( $task->task );
        my $comment = $form->get_element( { name => 'comment' } );
        $comment->value( $task->comment );
    }
    $c->stash( template => 'tasks/create.tt2' );
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
