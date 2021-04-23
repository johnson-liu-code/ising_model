// ################################################################################################## //
//                                     ising_model.cu                                                 //
// ################################################################################################## //
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Johnson Liu ( j_liu21@u.pacific.edu ) 20210422                                                     //
// University of the Pacific                                                                          //
// CA USA                                                                                             //
////////////////////////////////////////////////////////////////////////////////////////////////////////
########################################################################################################
--------------------------------------------------------------------------------------------------------
Functions of the code: ---------------------------------------------------------------------------------
    1)

--------------------------------------------------------------------------------------------------------
Notes: -------------------------------------------------------------------------------------------------
    1)

--------------------------------------------------------------------------------------------------------
Input: -------------------------------------------------------------------------------------------------
    1)

--------------------------------------------------------------------------------------------------------
Output: ------------------------------------------------------------------------------------------------
    A) To screen:
        1)

    B) Printed to ... :
        1)
--------------------------------------------------------------------------------------------------------
########################################################################################################
--------------------------------------------------------------------------------------------------------
1st Update

--------------------------------------------------------------------------------------------------------

########################################################################################################
*/
// =====================================================================================================
// Import libraries to use various functions.
#include <time.h>                   // For measuring runtimes.
#include <sys/time.h>               // For measuring runtimes.
#include <stdlib.h>                 /* srand, rand */
#include <stdio.h>                  // For interaction with console.
#include <iostream>                 // For printing to screen (std::cout, std::endl).
#include <cuda.h>                   // For CUDA parallelization on GPU.
// =====================================================================================================


void initialize_lattice( int *grid, int length )
{
    int i, j, index;
    float r;
    for ( i = 0; i < length; i++ )
    {
        for ( j = 0; j < length; j++ )
        {
            r = static_cast <float> (rand()) / static_cast <float> (RAND_MAX);
            index = length * i + j;

            if ( r <= 0.5 )
            {
                (grid)[ index ] = -1;
            }
            else
            {
                (grid)[ index ] = 1;
            }
        }
    }
}

void print_lattice( int *grid, int length )
{
    int i, j, index;
    for ( i = 0; i < length; i++)
    {
        for ( j = 0; j < length; j++ )
        {
            index = length * i + j;
            std::cout << (grid)[ index ] << std::endl;
        }
    }
}

void determine_ij( int i, int j, int length )
{
    int i_up, i_down, j_left, j_right;

    if ( i == 0 )
    {
        i_up = 1;
        i_down = length - 1;
    }
    else if ( i == length - 1)
    {
        i_up = 0;
        i_down = i - 1;
    }
    else
    {
        i_up = i + 1;
        i_down = i - 1;
    }
    if ( j == 0 )
    {
        j_left = length - 1;
        j_right = 1;
    }
    else if ( j == length - 1)
    {
        j_left = j - 1;
        j_right = 0;
    }
    else
    {
        j_left = j - 1;
        j_right = j + 1;
    }

    // int *ij;
    // ij = (int *)malloc( sizeof(int) * 4 );
    ij[0] = i_up;
    ij[1] = i_down;
    ij[2] = j_left;
    ij[3] = j_right;
}

void accept_reject( float x1, float y, float a, float q, float r, float m )
{
    x1 = a * (x1 % q) - (r * x1)/q

    if ( x1 < 0 )
    {
        x1 += m;
    }

    float r1 = x1 / m;

    x1r1[0] = x1;
    x1r1[0] = r1;
}

void update_lattice( int *grid, int length, float J, float beta, float x1,
                        float a, float q, float r, float m )
{
    int i, j, index, up_index, down_index, left_index, right_index;

    float energy_old, energy_new, y;
    bool change;


    for ( i = 0; i < length; i++)
    {
        for ( j = 0; j < length; j++ )
        {
            index = length * i + j;
            determine_ij( i, j, length );

            up_index    = length * ij[0] + j;
            down_index  = length * ij[1] + j;
            left_index  = length * i + ij[2];
            right_index = length * i + ij[3];

            energy_old = -J * (grid)[ index ] * ( (grid)[ up_index ] + (grid)[ down_index ]
                + (grid)[ left_index ] + (grid)[ right_index ] );

            energy_new = - energy_old;

            if ( energy_new <= energy_old )
            {
                change = TRUE;
            }
            else
            {
                y = exp( -beta * (E_new - E_old) );
                accept_reject( x1, y, a, q, r, m );

                x1 = x1r1[0];
                r1 = x1r1[1];

                if ( r1 <= y )
                {
                    change = TRUE;
                }
                else
                {
                    change = FALSE;
                }
            }

            if ( change == TRUE )
            {
                (grid)[ index ] = -(grid)[ index ];
            }

            // std::cout << "up: " << ij[0] << ", down: " << ij[1] << ", left: " << ij[2] << ", right: " << ij[3] << std::endl;
        }
    }
}



int main( int argc, char *argv[] )
{
    if ( argc != 2 )
    {
        // Print out the necessary command line imputs.
        printf( "Arguments for execution: %s <filename> <length>\n", argv[0] );
    }

    int length = std::stoi( argv[1] );
    int size = length * length;

    int *grid;
    grid = (int *)malloc( sizeof(int) * size );

    int *ij;
    ij = (int *)malloc( sizeof(int) * 4 );

    float *x1r1;
    x1r1 = (int *)malloc( sizeof(int) * 2 );

    initialize_lattice( grid, length );
    print_lattice( grid, length );
    update_lattice( grid, length );









}
